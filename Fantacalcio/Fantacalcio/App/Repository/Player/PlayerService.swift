//
//  PlayerServiceProtocol.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//


import Foundation

protocol PlayerServiceProtocol {
    func fetchPlayers() async throws -> [Player]
}

final class PlayerService: PlayerServiceProtocol {
    private let url = URL(string: "https://content.fantacalcio.it/test/test.json")!

    func fetchPlayers() async throws -> [Player] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Player].self, from: data)
    }
}