//
//  DashboardView+Navigable.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 05/07/2025.
//

import SwiftUI

extension DashboardView {
    static func create() -> UIViewController {
        let view = DashboardView()
        
        return UIHostingController(rootView: view)
    }
}
