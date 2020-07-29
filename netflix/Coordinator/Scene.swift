//
//  Scene.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case splash
    case tabbar
    case login
    case onboarding
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabbar:
            let rootTabbarController = AnimatedTabBarController.instantiate()
            
            let homeViewModel = HomeViewModel()
            let homeViewController = HomeViewController.instantiate(withViewModel: homeViewModel)
            let homeNavController = UINavigationController(rootViewController: homeViewController)
            let homeTabbarItem = UITabBarItem(title: Strings.home, image: Asset.tabIconHomeNormal.image, selectedImage: Asset.tabIconHomeNormal.image)
            homeNavController.tabBarItem = homeTabbarItem
            
            let searchViewModel = SearchViewModel()
            let searchViewController = SearchViewController.instantiate(withViewModel: searchViewModel)
            let searchNavController = UINavigationController(rootViewController: searchViewController)
            let searchTabbarItem = UITabBarItem(title: Strings.search, image: Asset.tabIconSearchNormal.image, selectedImage: Asset.tabIconSearchNormal.image)
            searchNavController.tabBarItem = searchTabbarItem
            
            let newMoviesViewModel = NewMoviesViewModel()
            let newMoviesViewController = NewMoviesViewController.instantiate(withViewModel: newMoviesViewModel)
            let newMoviesNavController = UINavigationController(rootViewController: newMoviesViewController)
            let newMoviesTabbarItem = UITabBarItem(title: Strings.comingSoon, image: Asset.extrasCardsIconNormal.image, selectedImage: Asset.extrasCardsIconNormal.image)
            newMoviesNavController.tabBarItem = newMoviesTabbarItem
            
            let myListViewModel = MyListViewModel()
            let myListViewController = MyListViewController.instantiate(withViewModel: myListViewModel)
            let myListNavController = UINavigationController(rootViewController: myListViewController)
            let myListTabbarItem = UITabBarItem(title: Strings.myList, image: Asset.icMylistNormal.image, selectedImage: Asset.icMylistNormal.image)
            myListNavController.tabBarItem = myListTabbarItem
            
            let moreViewModel = MoreViewModel()
            let moreViewController = MoreViewController.instantiate(withViewModel: moreViewModel)
            let moreNavController = UINavigationController(rootViewController: moreViewController)
            let moreTabbarItem = UITabBarItem(title: Strings.more, image: Asset.mcflyMoreNormal.image, selectedImage: Asset.mcflyMoreNormal.image)
            moreNavController.tabBarItem = moreTabbarItem
            
            
            rootTabbarController.viewControllers = [homeNavController, searchNavController, newMoviesNavController, myListNavController, moreNavController]
            return .tabBar(rootTabbarController)
        case .login:
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController.instantiate(withViewModel: loginViewModel)
            return .push(loginViewController)
        case .onboarding:
            let onboardingViewController = OnboardingViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: onboardingViewController)
            return .root(navigationController)
        case .splash:
            let splashViewController = SplashViewController.instantiate()
            return .root(splashViewController)
        }
    }
}
