//
//  MainTabBar.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 04/07/2025.
//


import SwiftUI

struct MainTabBar: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainTabBarController
    let mainTabBarController = MainTabBarController()

    func makeUIViewController(context: Context) -> MainTabBarController {
        mainTabBarController
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {
        uiViewController.config()
    }

    func getViewControllers() -> [UINavigationController] {
        guard let viewControllers = mainTabBarController.viewControllers as? [UINavigationController] else { return [] }

        return viewControllers
    }
}
