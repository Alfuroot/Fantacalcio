//
//  SponsorService.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//
import Foundation

protocol SponsorServiceProtocol {
    func fetchSponsors() async throws -> [SponsorResponse]
}

final class SponsorService: SponsorServiceProtocol {
    private let url = URL(string: "https://content.fantacalcio.it/test/sponsor.json")!

    func fetchSponsors() async throws -> [SponsorResponse] {
        
        return try await InMemoryCache.current.getOrFetch(for: .banners) {
            let (data, _) = try await URLSession.shared.data(from: self.url)
            return try JSONDecoder().decode([SponsorResponse].self, from: data)
        }
    }
}
