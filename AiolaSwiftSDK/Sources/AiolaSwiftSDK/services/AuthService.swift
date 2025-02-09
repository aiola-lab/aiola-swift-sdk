//
//  StreamingConfig.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

public func getAuthHeaders(authType: String, authCredentials: [String: Any]) throws -> AuthHeaders {
    switch authType {
    case "Cookie":
        guard let cookie = authCredentials["cookie"] as? String else {
            throw AuthenticationError.missingCredential("Cookie value is required for Cookie authentication")
        }
        return AuthHeaders(headers: ["Cookie": cookie])
    
    case "Bearer":
        guard let token = authCredentials["token"] as? String else {
            throw AuthenticationError.missingCredential("Token is required for Bearer authentication")
        }
        return AuthHeaders(headers: ["Authorization": "Bearer \(token)"])
    
    case "x-api-key":
        guard let apiKey = authCredentials["api_key"] as? String else {
            throw AuthenticationError.missingCredential("API key is required for x-api-key authentication")
        }
        return AuthHeaders(headers: [
            "x-api-key": apiKey,
            "Content-Type": "application/json"
        ])
    
    default:
        throw AuthenticationError.unsupportedAuthType("Unsupported authentication type: \(authType)")
    }
}
