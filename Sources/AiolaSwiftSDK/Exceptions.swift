//
//  Exceptions.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

public enum AuthenticationError: Error {
    case missingCredential(String)
    case unsupportedAuthType(String)
}
