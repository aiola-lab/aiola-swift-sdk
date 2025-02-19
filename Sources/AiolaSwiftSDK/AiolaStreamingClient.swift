//
//  StreamingConfig.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation
import SocketIO


public class AiolaStreamingClient {
    private var manager: SocketManager
    private var socket: SocketIOClient
    private var config: StreamingConfig
    private var stats: StreamingStats
    public weak var delegate: AiolaStreamingDelegate?
    
    public init(config: StreamingConfig) {
        self.config = config
        self.stats = StreamingStats(totalAudioSentDuration: 0, connectionStartTime: nil)
        
        let params = [
            "flow_id": config.flowId,
            "execution_id": config.executionId,
            "lang_code": config.langCode,
            "time_zone": config.timeZone
        ]
        
        let endpoint = "\(config.endpoint)\(config.namespace)?"
        
        print("Connecting to: \(endpoint)")
        
        
        let extraHeaders = (try? getAuthHeaders(authType: config.authType, authCredentials: config.authCredentials))?.headers ?? [:]
        
        self.manager = SocketManager(socketURL: URL(string: endpoint)!, config: [
            .log(false),
            .secure(true),
            .connectParams(params),
            .extraHeaders(extraHeaders),
            .path("/api/voice-streaming/socket.io"),
            .forceWebsockets(config.transports == "websocket")
        ])
        
        self.socket = manager.socket(forNamespace: config.namespace )
        setupEventHandlers()
    }
    
    private func setupEventHandlers() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else { return }
            self.stats.connectionStartTime = Date().timeIntervalSince1970
            self.delegate?.onConnect()
        }
        
        socket.on(clientEvent: .error) { [weak self] data, ack in
            guard let self = self else { return }
            if let error = data.first as? String {
                self.delegate?.onError(error: error)
            }
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            guard let self = self else { return }
            let connectionDuration = Date().timeIntervalSince1970 - (self.stats.connectionStartTime ?? 0)
            self.delegate?.onDisconnect(connectionDuration: connectionDuration, totalAudioSentDuration: self.stats.totalAudioSentDuration)
        }
        
        socket.on("transcript") { [weak self] data, ack in
            self?.delegate?.onTranscript(data: data)
            ack.with(["status": "received"])
        }
        
        socket.on("events") { [weak self] data, ack in
            self?.delegate?.onEvents(data: data)
            ack.with(["status": "received"])
        }
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func disconnect() {
        socket.disconnect()
    }
    
    public func setKeywords(kws: [String]) {
        guard socket.status == .connected else {
            delegate?.onError(error: "Socket not connected")
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(kws)
        socket.emit("set_keywords", data)
    }
    
    public func sendAudioData(data: Data, completion: @escaping (Bool) -> Void) {
        let dataMessage = Data(data)  // 🔹 Clone of original `Data` object

        if socket.status == SocketIOStatus.connected {
            socket.emit("binary_data", dataMessage)  // ✅ Send cloned data
            completion(true)
        } else {
            completion(false)
        }
    }
}
