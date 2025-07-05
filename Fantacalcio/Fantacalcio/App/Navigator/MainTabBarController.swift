//
//  MainTabBarController.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 04/07/2025.
//


import SwiftUI
import Combine

class MainTabBarController: UITabBarController {
    private var upperLineView: UIView!
    private let navigator = Navigator.current
    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        self.createTabs()
        self.setTabBarStyle()
        self.addTabBarIndicatorView(isFirstTime: true)

        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)

        navigator.changeTabPublisher
            .filter { [MainRoot.dashboard, MainRoot.favourites].contains($0) }
            .map {
                switch $0 {
                    case .dashboard:
                        return 0
                    case .favourites:
                        return 1
                    default:
                        return nil
                }
            }
            .compactMap { $0 }
            .sink { [weak self] newIndex in
                guard let self = self else { return }
                self.selectedIndex = newIndex
                self.addTabBarIndicatorView()
            }
            .store(in: &bag)
    }

    func config() {
        self.addTabBarIndicatorView()
        self.setTabBarStyle()
    }

    private func setTabBarStyle(isEnabled: Bool = true) {
        let appearance = UITabBarAppearance()

        appearance.backgroundColor = .lightGrayFanta

        var titleTextAttributes: [NSAttributedString.Key: Any] = [:]

  

        titleTextAttributes.updateValue(UIColor.gray,
										forKey: .foregroundColor)
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = titleTextAttributes
        
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.standardAppearance = appearance
        self.tabBar.isUserInteractionEnabled = isEnabled
        self.tabBar.tintColor = UIColor.systemBlue

        upperLineView?.backgroundColor = .systemBlue

    }

    private func createTabs() {
        var viewControllers: [UIViewController] = []

        // Dashboard
        let dashboard = DashboardView.create()
        let dashboardHostingNavigation = UINavigationController(rootViewController: dashboard)
        dashboardHostingNavigation.tabBarItem = UITabBarItem(title: "Lista calciatori", image: UIImage(named: "dashboardIcon"), tag: 0)
        viewControllers.append(dashboardHostingNavigation)

        // Favourites
        let favourites = FavouritesView.create()
		let favouritesHostingNavigation = UINavigationController(rootViewController: favourites)
        favouritesHostingNavigation.tabBarItem = UITabBarItem(title: "Preferiti", image: UIImage(named: "favouritesIcon"), tag: 1)
		viewControllers.append(favouritesHostingNavigation)

        for (index, vc) in viewControllers.enumerated() {
            print("VC[\(index)] is \(type(of: vc))")
        }
        
        self.setViewControllers(viewControllers, animated: true)
    }

    deinit {
        self.bag.removeAll()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    @objc private func orientationDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.addTabBarIndicatorView()
        }
    }

    private func addTabBarIndicatorView(isFirstTime: Bool = false, isMoreTab: Bool = false) {
        var tabView: UIView?
        if isMoreTab {
            tabView = self.tabBar.items?.last?.value(forKey: "view") as? UIView
        } else {
            guard selectedIndex < self.tabBar.items?.count ?? 0 else { return }
            tabView = self.tabBar.items?[self.selectedIndex].value(forKey: "view") as? UIView
        }

        guard let tabView = tabView else { return }

        let newFrame = CGRect(
            x: tabView.frame.minX,
            y: tabView.frame.minY - 1,
            width: tabView.frame.size.width,
            height: 2.5
        )

        if isFirstTime {
            upperLineView = UIView(frame: newFrame)
            upperLineView.backgroundColor = .systemBlue
            tabBar.addSubview(upperLineView)
        } else {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                upperLineView.backgroundColor = .systemBlue
                self.upperLineView.frame = newFrame
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
            case 0:
                Navigator.current.currentlySelectedTab = .dashboard
            case 1:
                Navigator.current.currentlySelectedTab = .favourites
            default:
                Navigator.current.currentlySelectedTab = .dashboard
        }
        self.addTabBarIndicatorView(isMoreTab: viewController == tabBarController.moreNavigationController)

		if let navController = viewController as? UINavigationController,
			navController.viewControllers.count > 1 {
            DispatchQueue.main.async {
                navController.popToRootViewController(animated: false)
            }
		}

    }
}
