//
//  Cache.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//


import Foundation

public protocol Cache {
    func getOrFetch<T>(
        for key: CacheKey,
        timeToLive: Int64,
        fetcher: @escaping () async throws -> T
    ) async throws -> T

    func put<T>(for key: CacheKey , value: T, timeToLive: Int64) -> Void

    func remove(for key: CacheKey) -> Void

    func contains(for key: CacheKey) -> Bool

    func clear() -> Void
}

public enum CacheKey {
    case players

    var key: String {
        switch self {
            case .players:
                "players"
        }
    }
}
