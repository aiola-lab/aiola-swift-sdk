//
//  AuthHeaders.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

// AuthHeaders: Holds request headers
public struct AuthHeaders {
    public let headers: [String: String]

    public init(headers: [String: String]) {
        self.headers = headers
    }
}
