//
//  Callbacks.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

public protocol AiolaStreamingDelegate: AnyObject {
    func onConnect()
    func onDisconnect(connectionDuration: TimeInterval, totalAudioSentDuration: TimeInterval)
    func onTranscript(data: Any)
    func onEvents(data: Any)
    func onError(error: String)
}

// Provide default implementation to make methods optional
public extension AiolaStreamingDelegate {
    func onConnect() {}
    func onDisconnect(connectionDuration: TimeInterval, totalAudioSentDuration: TimeInterval) {}
    func onTranscript(data: Any) {}
    func onEvents(data: Any) {}
    func onError(error: String) {}
}
