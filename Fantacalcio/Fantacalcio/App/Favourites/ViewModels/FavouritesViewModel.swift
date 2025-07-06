//
//  FavouritesViewModel.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//

import Foundation

@MainActor
final class FavouritesViewModel: ObservableObject {
    @Published var players: [Player] = []

    private let playerService: PlayerServiceProtocol = PlayerService()

    @Published var sponsorsBySection: [String: [Sponsor]] = [:]
    @Published var currentSponsorBySection: [String: Sponsor] = [:]

    private let sponsorService: SponsorServiceProtocol = SponsorService()

    func fetchPlayers() async {
        do {
            let allPlayers = try await playerService.fetchPlayers()
            let favouriteIds = getFavouriteIds()
            let filtered = allPlayers.filter { favouriteIds.contains($0.playerId) }
            players = filtered.sorted(by: {
                if $0.teamAbbreviation == $1.teamAbbreviation {
                    return $0.playerName < $1.playerName
                } else {
                    return $0.teamAbbreviation < $1.teamAbbreviation
                }
            })
        } catch {
            print("Error fetching players: \(error)")
        }
    }

    private func getFavouriteIds() -> [Int] {
        UserDefaults.standard.array(forKey: "favouritePlayerIds") as? [Int] ?? []
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
