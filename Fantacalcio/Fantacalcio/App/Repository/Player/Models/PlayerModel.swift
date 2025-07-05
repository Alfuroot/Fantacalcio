//
//  Player.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//


import Foundation

struct Player: Identifiable, Codable, Equatable {
    let playerId: Int
    let playerName: String
    let imageURL: String
    let teamAbbreviation: String
    let gamesPlayed: Int
    let averageGrade: Double
    let averageFantaGrade: Double

    var id: Int { playerId }
}
