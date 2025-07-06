//
//  DashboardRowItem.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//


//
//  DashboardRowItem.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 04/07/2025.
//

import SwiftUI

struct FavouriteRowItem: View {
    let player: Player

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: player.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
            } placeholder: {
                ProgressView()
                    .frame(width: 40, height: 40)
            }
            .background(
                Circle()
                    .fill(Color.grayFanta)
                    .frame(width: 54, height: 54)
            )
            .padding(.leading, 16)
            .padding([.trailing, .top, .bottom], 8)

            VStack(alignment: .leading) {
                Text(player.playerName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.darkBlueFanta)
                    .tracking(0.5)
                    .padding(.bottom, 4)

                Text(player.teamAbbreviation)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                    .tracking(0.5)
            }

            Spacer()
            
            Text("\(player.gamesPlayed)")
                .font(.system(size: 14))
                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                .tracking(0.5)
                .padding(.trailing, 8)

            Text(String(format: "%.2f", player.averageGrade))
                .font(.system(size: 14))
                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                .tracking(0.5)
                .padding(.trailing, 8)

            Text(String(format: "%.2f", player.averageFantaGrade))
                .font(.system(size: 14))
                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                .tracking(0.5)
                .padding(.trailing, 16)
        }
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightGrayFanta)
        )
        .padding(.bottom, 8)
    }
}
