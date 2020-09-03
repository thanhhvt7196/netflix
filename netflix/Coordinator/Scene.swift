//
//  Scene.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case splash
    case tabbar
    case login
    case onboarding
    case webView(url: String)
    case movieDetail(movie: Media)
    case player(video: Video)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabbar:
            let rootTabbarController = AnimatedTabBarController.instantiate()
            
            let homeViewModel = HomeViewModel()
            let homeViewController = HomeViewController.instantiate(withViewModel: homeViewModel)
            let homeNavController = BaseNavigationController(rootViewController: homeViewController)
            let homeTabbarItem = UITabBarItem(title: Strings.home, image: Asset.tabIconHomeNormal.image, selectedImage: Asset.tabIconHomeNormal.image)
            homeNavController.tabBarItem = homeTabbarItem
            
            let searchViewModel = SearchViewModel()
            let searchViewController = SearchViewController.instantiate(withViewModel: searchViewModel)
            let searchNavController = BaseNavigationController(rootViewController: searchViewController)
            let searchTabbarItem = UITabBarItem(title: Strings.search, image: Asset.tabIconSearchNormal.image, selectedImage: Asset.tabIconSearchNormal.image)
            searchNavController.tabBarItem = searchTabbarItem
            
            let newMoviesViewModel = NewMoviesViewModel()
            let newMoviesViewController = NewMoviesViewController.instantiate(withViewModel: newMoviesViewModel)
            let newMoviesNavController = BaseNavigationController(rootViewController: newMoviesViewController)
            let newMoviesTabbarItem = UITabBarItem(title: Strings.comingSoon, image: Asset.extrasCardsIconNormal.image, selectedImage: Asset.extrasCardsIconNormal.image)
            newMoviesNavController.tabBarItem = newMoviesTabbarItem
            
            let myListViewModel = MyListViewModel(isTabbarItem: true)
            let myListViewController = MyListViewController.instantiate(withViewModel: myListViewModel)
            let myListNavController = BaseNavigationController(rootViewController: myListViewController)
            let myListTabbarItem = UITabBarItem(title: Strings.myList, image: Asset.icMylistNormal.image, selectedImage: Asset.icMylistNormal.image)
            myListNavController.tabBarItem = myListTabbarItem
            
            let moreViewModel = MoreViewModel()
            let moreViewController = MoreViewController.instantiate(withViewModel: moreViewModel)
            let moreNavController = BaseNavigationController(rootViewController: moreViewController)
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
            let navigationController = BaseNavigationController(rootViewController: onboardingViewController)
            return .root(navigationController)
        case .splash:
            let splashViewModel = SplashViewModel()
            let splashViewController = SplashViewController.instantiate(withViewModel: splashViewModel)
            return .root(splashViewController)
        case .webView(let url):
            let webViewModel = WebViewModel(url: url)
            let webviewController = WebViewController.instantiate(withViewModel: webViewModel)
            let navigationController = BaseNavigationController(rootViewController: webviewController)
            return .present(navigationController)
        case .movieDetail(let movie):
            let movieDetailViewModel = MovieDetailViewModel(media: movie)
            let movieDetailViewController = MovieDetailViewController.instantiate(withViewModel: movieDetailViewModel)
            return .push(movieDetailViewController)
        case .player(let video):
            let playerViewModel = PlayerViewModel(video: video)
            let playerViewController = PlayerViewController.instantiate(withViewModel: playerViewModel)
            playerViewController.hidesBottomBarWhenPushed = true
            return .push(playerViewController)
        }
    }
}
