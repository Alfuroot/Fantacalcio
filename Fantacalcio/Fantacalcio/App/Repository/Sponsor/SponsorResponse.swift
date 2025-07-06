//
//  SponsorResponse.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//


import Foundation

struct SponsorResponse: Codable {
    let main: [Sponsor]
    let sectionId: String
    let description: String
}

struct Sponsor: Codable, Equatable {
    let tapUrl: String?
    let image: String?
}
