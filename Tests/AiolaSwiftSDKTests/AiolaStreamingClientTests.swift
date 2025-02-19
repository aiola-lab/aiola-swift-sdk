//
//  AiolaStreamingClientTests.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import XCTest
@testable import AiolaSwiftSDK

class AiolaStreamingClientTests: XCTestCase, AiolaStreamingDelegate {
    
    var client: AiolaStreamingClient!
    let expectationTimeout: TimeInterval = 10
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        
        let bearerToken = "<your-bearer-token>"
        
        let config = StreamingConfig(
                endpoint: "<your-base-url>",
                authType: "Bearer",
                authCredentials: ["token": bearerToken],
                flowId: "<your-flow-id>",
                executionId: "1009", // ✅ Moved executionId before namespace
                langCode: "en_US",
                timeZone: "UTC",
                namespace: "/events",
                transports: "websocket"
            )

        client = AiolaStreamingClient(config: config)
        client.delegate = self
    }

    func testConnection() {
        expectation = expectation(description: "Client should connect successfully")
        client.connect()
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    // MARK: - Delegate Methods (Test Event Handlers)

    func onConnect() {
        print("✅ Connection established")
        expectation.fulfill()
    }
    
    func onDisconnect(connectionDuration: TimeInterval, totalAudioSentDuration: TimeInterval) {
        print("❌ Connection closed. Duration: \(connectionDuration)ms, Total audio: \(totalAudioSentDuration)ms")
    }
    
    func onTranscript(data: Any) {
        print("📝 Transcript received: \(data)")
        expectation.fulfill()
    }
    
    func onEvents(data: Any) {
        print("📢 Events received: \(data)")
    }
    
    func onError(error: String) {
        print("⚠️ Error occurred: \(error)")
    }
}
