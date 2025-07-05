//
//  DashboardViewModel.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//

import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var searchText: String = ""

    private let playerService: PlayerServiceProtocol  = PlayerService()

    func fetchPlayers() async {
        do {
            let result = try await playerService.fetchPlayers()
            self.players = result
        } catch {
            print("Error fetching players: \(error)")
        }
    }

    var filteredPlayers: [Player] {
        guard !searchText.isEmpty else { return players }
        return players.filter {
            $0.playerName.localizedCaseInsensitiveContains(searchText)
        }
    }
}
