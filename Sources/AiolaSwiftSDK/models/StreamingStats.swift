//
//  StreamingStats.swift
//  AiolaSwiftSDK
//
//  Created by Amour Shmuel on 05/02/2025.
//

import Foundation

public struct StreamingStats: Codable {
    public var totalAudioSentDuration: TimeInterval
    public var connectionStartTime: TimeInterval?
    
    public init(
        totalAudioSentDuration: TimeInterval = 0,
        connectionStartTime: TimeInterval? = nil
    ) {
        self.totalAudioSentDuration = totalAudioSentDuration
        self.connectionStartTime = connectionStartTime
    }
}
