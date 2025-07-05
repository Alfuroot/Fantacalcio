//
//  DashboardRowItem.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 04/07/2025.
//

import SwiftUI

struct DashboardRowItem: View {
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

                Text(player.teamAbbreviation)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                    .tracking(0.5)
            }

            Spacer()
        }
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightGrayFanta)
        )
    }
}
