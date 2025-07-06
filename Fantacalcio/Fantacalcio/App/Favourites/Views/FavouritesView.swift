//
//  FavouritesView.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel: FavouritesViewModel
    @State private var sponsor: Sponsor?
    
    init(viewModel: FavouritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        SponsorNavigationView(
            currentSection: .favourites,
            bannerImageUrl: URL(string: sponsor?.image ?? ""),
            tapAction: {
                if let urlString = sponsor?.tapUrl, let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        ) {
            VStack(spacing: 12) {
                if !viewModel.players.isEmpty {
                    ScrollView {
                        HStack {
                            Text("Calciatore")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                                .tracking(0.5)
                                .padding(.leading, 16)
                            Spacer()
                            Text("PG")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                                .tracking(0.5)
                                .padding(.trailing, 8)
                            Text("MV")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                                .tracking(0.5)
                                .padding(.trailing, 8)
                            Text("MFV")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.darkBlueFanta.opacity(0.7))
                                .tracking(0.5)
                                .padding(.trailing, 32)
                        }
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.players) { player in
                                FavouriteRowItem(player: player)
                            }
                        }
                        .padding(.top, 0)
                        .padding(.horizontal, 16)
                    }
                } else {
                    Spacer()
                    Text("Nessun preferito")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.darkGrayFanta)
                        .tracking(0.5)
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.fetchPlayers()
            await viewModel.fetchSponsors()
            sponsor = viewModel.currentSponsorBySection["FAVOURITES"]
        }
        .onAppear {
            sponsor = viewModel.nextSponsor(for: "FAVOURITES")
        }
    }
}

#Preview {
    FavouritesView(viewModel: .init())
}
