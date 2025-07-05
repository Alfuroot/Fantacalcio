//
//  Navigator.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 04/07/2025.
//

import SwiftUI
import Combine

public final class Navigator: ObservableObject {
    static let current = Navigator()
    private var childNavigationControllers: [MainRoot: UINavigationController] = [:]
    private var tabBar: MainTabBar?
    private var mainTabBar: UIViewController?
    var changeTabPublisher = PassthroughSubject<MainRoot, Never>()
    public var currentlySelectedTab: MainRoot = .dashboard

    init() {}

    @MainActor @ViewBuilder
    func createMainRoute() -> some View {
        createMainTabBar()
            .ignoresSafeArea()
    }

    private func createMainTabBar() -> some View {
        if let tabBar = self.tabBar, !childNavigationControllers.isEmpty {
            return tabBar
        }
        let tabBar = MainTabBar()
           
        let viewControllers = tabBar.getViewControllers()
        self.childNavigationControllers.updateValue(viewControllers[0], forKey: .dashboard)
        self.childNavigationControllers.updateValue(viewControllers[1], forKey: .favourites)

        self.mainTabBar = tabBar.mainTabBarController
        self.tabBar = tabBar

        return tabBar
    }


    // MARK: - Navigation Logic
    func getViewController(from root: MainRoot) -> UIViewController? {
        return root == .mainTabBar ? self.mainTabBar : self.childNavigationControllers[root]
    }

    func changeTab(root: MainRoot) {
        guard [MainRoot.dashboard, MainRoot.favourites].contains(root) else { return }
        self.changeTabPublisher.send(root)
        currentlySelectedTab = root
    }
}
