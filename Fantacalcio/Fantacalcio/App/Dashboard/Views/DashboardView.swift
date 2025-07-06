//
//  ContentView.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 02/07/2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var sponsor: Sponsor?
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        SponsorNavigationView(
            bannerImageUrl: URL(string: sponsor?.image ?? ""),
            tapAction: {
                if let urlString = sponsor?.tapUrl, let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        ) {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Ricerca calciatore", text: $viewModel.searchText)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }
                .padding(10)
                .background(Color.lightGrayFanta)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
                if !viewModel.filteredPlayers.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.filteredPlayers) { player in
                                DashboardRowItem(
                                    player: player,
                                    isFavorite: .constant(viewModel.isFavorite(player)),
                                    toggleFavorite: { viewModel.toggleFavorite(player) }
                                )
                            }
                        }
                        .padding(.top, 0)
                        .padding(.horizontal, 16)
                    }
                } else {
                    Spacer()
                    Text("La ricerca non ha prodotto risultati")
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
            sponsor = viewModel.currentSponsorBySection["PLAYERS_LIST"]
        }
        .onAppear {
            sponsor = viewModel.nextSponsor(for: "PLAYERS_LIST")
        }
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel())
}
