//
//  FavouritesView+Navigation.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//

import SwiftUI

extension FavouritesView {
    static func create() -> UIViewController {
        let viewModel = FavouritesViewModel()
        let view = FavouritesView(viewModel: viewModel)

        return UIHostingController(rootView: view)
    }
}
