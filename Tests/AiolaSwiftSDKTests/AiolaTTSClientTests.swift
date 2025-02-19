//
//  AiolaTTSClientTests.swift
//  AiolaSwiftSDKTests
//
//  Created by Amour Shmuel on 06/02/2025.
//

import XCTest
@testable import AiolaSwiftSDK

final class AiolaTTSClientTests: XCTestCase {
    
    var ttsClient: AiolaTTSClient!

    override func setUp() {
        super.setUp()
        ttsClient = AiolaTTSClient(baseUrl: "<your-base-url>/api/tts", bearerToken: "<your-bearer-token>")
    }

    override func tearDown() {
        ttsClient = nil
        super.tearDown()
    }

    /// ✅ Test Successful Text-to-Speech Conversion
    func testSynthesizeSuccess() {
        let expectation = self.expectation(description: "Synthesize TTS")

        ttsClient.synthesize(text: "Hello, world!") { result in
            switch result {
            case .success(let audioData):
                XCTAssertGreaterThan(audioData.count, 0, "Audio data should not be empty")
                print("✅ Received TTS audio data: \(audioData.count) bytes")
            case .failure(let error):
                XCTFail("❌ TTS request failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    /// ✅ Test Successful TTS Streaming
    func testSynthesizeStreamSuccess() {
        let expectation = self.expectation(description: "Synthesize Stream")

        ttsClient.synthesizeStream(text: "Streaming works!") { result in
            switch result {
            case .success(let audioData):
                XCTAssertGreaterThan(audioData.count, 0, "Streamed audio data should not be empty")
                print("✅ Received TTS stream data: \(audioData.count) bytes")
            case .failure(let error):
                XCTFail("❌ Stream request failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    /// ❌ Test Missing Text Input for TTS
    func testSynthesizeMissingText() {
        let expectation = self.expectation(description: "Missing text validation")

        ttsClient.synthesize(text: "") { result in
            switch result {
            case .success:
                XCTFail("❌ Should fail when text is empty")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "Text is required for synthesis", "❌ Unexpected error message")
                print("✅ Error correctly handled: \(error.domain)")
            default:
                XCTFail("❌ Unexpected error type")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }


    /// ❌ Test API Failure (Invalid Token or Server Error)
    func testSynthesizeApiFailure() {
        let expectation = self.expectation(description: "TTS API failure")

        ttsClient = AiolaTTSClient(baseUrl: "<your-base-url>/api/tts", bearerToken: "invalid_token")

        ttsClient.synthesize(text: "This should fail") { result in
            switch result {
            case .success:
                XCTFail("❌ Should not succeed with invalid token")
            case .failure(let error):
                print("✅ Expected failure: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
