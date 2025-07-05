//
//  DashboardView+Navigable.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//

import SwiftUI

extension DashboardView {
    static func create() -> UIViewController {
        let viewModel = DashboardViewModel()
        let view = DashboardView(viewModel: viewModel)
        
        return UIHostingController(rootView: view)
    }
}
