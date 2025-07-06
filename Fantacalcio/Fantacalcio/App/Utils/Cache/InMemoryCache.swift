//
//  InMemoryCache.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//


import Foundation

public final class InMemoryCache: Cache {
    public static let current = InMemoryCache()
    private let queue = DispatchQueue(label: "cacheQueue", attributes: .concurrent)

    private init() {  }

    private var entries: Dictionary<String, Entry> = [:]

    internal struct Entry {
        let value: Any
        let timeToLive: Int64
        let timestamp: Int64

        var isExpired: Bool {
            Int64(Date.now.timeIntervalSince1970 * 1000) - timestamp > timeToLive
        }

        init(value: Any, timeToLive: Int64) {
            self.value = value
            self.timeToLive = timeToLive
            self.timestamp = Int64(Date.now.timeIntervalSince1970 * 1000)
        }
    }

    public func getOrFetch<T>(for key: CacheKey, timeToLive: Int64 = 300_000, fetcher: @escaping () async throws -> T) async throws -> T {
        if isExpired(for: key) {
            remove(for: key)
        }

        guard contains(for: key), let entry = entries[key.key] else {
            let newEntryValue = try await fetcher()
            put(for: key, value: newEntryValue, timeToLive: timeToLive)
            return newEntryValue
        }

        guard let value = entry.value as? T else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid type"))
        }

        return value
    }

    public func put<T>(for key: CacheKey, value: T, timeToLive: Int64) {
        queue.async(flags: .barrier) { [weak self] in
            let newEntry = Entry(value: value, timeToLive: timeToLive)
            self?.entries.updateValue(newEntry, forKey: key.key)
        }
    }

    public func remove(for key: CacheKey) {
        queue.async(flags: .barrier) { [weak self] in
            self?.entries.removeValue(forKey: key.key)
        }
    }

    public func removeAllKeys(with prefix: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self.entries = self.entries
                .filter { !$0.key.hasPrefix(prefix) }
        }
    }

    public func contains(for key: CacheKey) -> Bool {
        queue.sync {
            entries.contains { $0.key ==  key.key }
        }
    }

    public func clear() {
		queue.sync {
			entries.removeAll()
		}
    }

    private func isExpired(for key: CacheKey) -> Bool {
        queue.sync {
            guard contains(for: key) else { return false }

            return entries[key.key]?.isExpired ?? true
        }
    }
}
