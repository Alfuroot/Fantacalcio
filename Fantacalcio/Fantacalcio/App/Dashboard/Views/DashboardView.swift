//
//  ContentView.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 02/07/2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.filteredPlayers) { player in
                DashboardRowItem(player: player)
                       .padding(.bottom, 8)
            }
            .searchable(text: $viewModel.searchText, prompt: "Ricerca calciatore")
            .task {
                await viewModel.fetchPlayers()
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel())
}

