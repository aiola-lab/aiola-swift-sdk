//
//  StreamingConfig.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

public struct StreamingConfig: Codable {
    public let endpoint: String
    public let authType: String
    public let authCredentials: [String: Any]
    
    // Stream parameters
    public let flowId: String
    public let executionId: String
    public let langCode: String
    public let timeZone: String
    public let namespace: String
    public let transports: String

    public init(
        endpoint: String,
        authType: String,
        authCredentials: [String: Any],
        flowId: String = "default_flow",
        executionId: String = "1",
        langCode: String = "en_US",
        timeZone: String = "UTC",
        namespace: String = "/events",
        transports: String = "polling"
    ) {
        self.endpoint = endpoint
        self.authType = authType
        self.authCredentials = authCredentials
        self.flowId = flowId
        self.executionId = executionId
        self.langCode = langCode
        self.timeZone = timeZone
        self.namespace = namespace
        self.transports = transports
    }
    
    // MARK: - Codable Manual Implementation
    
    enum CodingKeys: String, CodingKey {
        case endpoint, authType, authCredentials, flowId, executionId, langCode, timeZone, namespace, transports
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endpoint, forKey: .endpoint)
        try container.encode(authType, forKey: .authType)
        try container.encode(flowId, forKey: .flowId)
        try container.encode(executionId, forKey: .executionId)
        try container.encode(langCode, forKey: .langCode)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(namespace, forKey: .namespace)
        try container.encode(transports, forKey: .transports)
        
        // Convert [String: Any] to Data for encoding
        let authData = try JSONSerialization.data(withJSONObject: authCredentials, options: [])
        let authString = String(data: authData, encoding: .utf8)
        try container.encode(authString, forKey: .authCredentials)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endpoint = try container.decode(String.self, forKey: .endpoint)
        authType = try container.decode(String.self, forKey: .authType)
        flowId = try container.decode(String.self, forKey: .flowId)
        executionId = try container.decode(String.self, forKey: .executionId)
        langCode = try container.decode(String.self, forKey: .langCode)
        timeZone = try container.decode(String.self, forKey: .timeZone)
        namespace = try container.decode(String.self, forKey: .namespace)
        transports = try container.decode(String.self, forKey: .transports)
        
        // Decode `authCredentials` from JSON string
        let authString = try container.decode(String.self, forKey: .authCredentials)
        if let authData = authString.data(using: .utf8),
           let decodedAuth = try? JSONSerialization.jsonObject(with: authData, options: []) as? [String: Any] {
            authCredentials = decodedAuth
        } else {
            authCredentials = [:]
        }
    }
}
