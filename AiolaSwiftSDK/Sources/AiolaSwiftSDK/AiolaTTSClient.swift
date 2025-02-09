//
//  AiolaTTSClient.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 06/02/2025.
//

import Foundation

public class AiolaTTSClient {
    private let baseUrl: String
    private let bearerToken: String

    /// Initialize the AiolaTTSClient
    public init(baseUrl: String, bearerToken: String) {
        guard !baseUrl.isEmpty else { fatalError("Base URL is required") }
        guard !bearerToken.isEmpty else { fatalError("Bearer Token is required") }

        self.baseUrl = baseUrl
        self.bearerToken = bearerToken
    }

    /// Helper method to send API requests
    private func request(endpoint: String, payload: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let bodyString = payload.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(data ?? Data()))
            } else {
                let errorMessage = "Request failed with status \(httpResponse.statusCode)"
                completion(.failure(NSError(domain: errorMessage, code: httpResponse.statusCode, userInfo: nil)))
            }
        }

        task.resume()
    }

    /// Convert text to speech and retrieve the audio file
    public func synthesize(text: String, voice: String = "af_bella", completion: @escaping (Result<Data, Error>) -> Void) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(NSError(domain: "Text is required for synthesis", code: 400, userInfo: nil)))
            return
        }

        let payload = ["text": text, "voice": voice]
        request(endpoint: "/synthesize", payload: payload, completion: completion)
    }

    /// Convert text to speech and stream the audio data
    public func synthesizeStream(text: String, voice: String = "af_bella", completion: @escaping (Result<Data, Error>) -> Void) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(NSError(domain: "Text is required for synthesis", code: 400, userInfo: nil)))
            return
        }

        let payload = ["text": text, "voice": voice]
        request(endpoint: "/synthesize/stream", payload: payload, completion: completion)
    }
}
