//
//  FantacalcioApp.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 02/07/2025.
//

import SwiftUI

@main
struct FantacalcioApp: App {

    @StateObject internal var navigator = Navigator.current

    var body: some Scene {
        WindowGroup {
            navigator.createMainRoute()
        }
    }
}
