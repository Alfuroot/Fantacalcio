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
    
    @Published var sponsorsBySection: [String: [Sponsor]] = [:]
    @Published var currentSponsorBySection: [String: Sponsor] = [:]

    private let sponsorService: SponsorServiceProtocol = SponsorService()
    
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
