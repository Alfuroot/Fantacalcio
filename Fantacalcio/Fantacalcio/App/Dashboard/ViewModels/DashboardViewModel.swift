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
    
    @Published private(set) var favoritePlayerIds: Set<Int> = []

    private let playerService: PlayerServiceProtocol  = PlayerService()
    
    @Published var sponsorsBySection: [String: [Sponsor]] = [:]
    @Published var currentSponsorBySection: [String: Sponsor] = [:]

    private let sponsorService: SponsorServiceProtocol = SponsorService()
    
    var filteredPlayers: [Player] {
        let filtered = searchText.isEmpty ? players : players.filter {
            $0.playerName.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { p1, p2 in
            let p1Fav = isFavorite(p1)
            let p2Fav = isFavorite(p2)
            
            if p1Fav != p2Fav {
                return p1Fav && !p2Fav
            } else if p1.teamAbbreviation != p2.teamAbbreviation {
                return p1.teamAbbreviation < p2.teamAbbreviation
            } else {
                return p1.playerName < p2.playerName
            }
        }
    }

    init() {
        loadFavorites()
    }

    func fetchPlayers() async {
        do {
            let result = try await playerService.fetchPlayers()
            self.players = result
        } catch {
            print("Error fetching players: \(error)")
        }
    }
    
    private func loadFavorites() {
        let saved = UserDefaults.standard.array(forKey: "favouritePlayerIds") as? [Int] ?? []
        favoritePlayerIds = Set(saved)
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoritePlayerIds), forKey: "favouritePlayerIds")
    }

    func isFavorite(_ player: Player) -> Bool {
        favoritePlayerIds.contains(player.playerId)
    }

    func toggleFavorite(_ player: Player) {
        if favoritePlayerIds.contains(player.playerId) {
            favoritePlayerIds.remove(player.playerId)
        } else {
            favoritePlayerIds.insert(player.playerId)
        }
        saveFavorites()
    }

    func fetchSponsors() async {
        do {
            let responses = try await sponsorService.fetchSponsors()
            var dict = [String: [Sponsor]]()
            var currentDict = [String: Sponsor]()
            
            for resp in responses {
                let filtered = resp.main.filter { $0.image?.isEmpty == false }
                dict[resp.sectionId] = filtered
                
                if !filtered.isEmpty {
                    let index = getLastSponsorIndex(for: resp.sectionId)
                    if index < filtered.count {
                        currentDict[resp.sectionId] = filtered[index]
                    } else {
                        setLastSponsorIndex(0, for: resp.sectionId)
                        currentDict[resp.sectionId] = filtered[0]
                    }
                }
            }
            
            sponsorsBySection = dict
            currentSponsorBySection = currentDict
            
        } catch {
            sponsorsBySection = [:]
            currentSponsorBySection = [:]
        }
    }
    
    func getLastSponsorIndex(for section: String) -> Int {
        UserDefaults.standard.integer(forKey: "SponsorIndex_\(section)")
    }
    
    func setLastSponsorIndex(_ index: Int, for section: String) {
        UserDefaults.standard.set(index, forKey: "SponsorIndex_\(section)")
    }
    
    func nextSponsor(for section: String) -> Sponsor? {
        guard let sponsors = sponsorsBySection[section], !sponsors.isEmpty else {
            return nil
        }
        
        let lastIndex = getLastSponsorIndex(for: section)
        let nextIndex = (lastIndex + 1) % sponsors.count
        setLastSponsorIndex(nextIndex, for: section)
        return sponsors[nextIndex]
    }
}
