//
//  Scene.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case tabbar
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabbar:
            let rootTabbarController = RootTabbarController.instantiate()
            
            let homeViewModel = HomeViewModel()
            let homeViewController = HomeViewController.instantiate(withViewModel: homeViewModel)
            let homeNavController = UINavigationController(rootViewController: homeViewController)
            let homeTabbarItem = RAMAnimatedTabBarItem(title: Strings.home, image: Asset.tabIconHomeNormal.image.tinted(color: .lightGray), selectedImage: Asset.mcflyBrowseNormal.image)
            homeTabbarItem.animation = RAMBounceAnimation()
            homeTabbarItem.animation.textSelectedColor = .white
            homeNavController.tabBarItem = homeTabbarItem
            
            let searchViewModel = SearchViewModel()
            let searchViewController = SearchViewController.instantiate(withViewModel: searchViewModel)
            let searchNavController = UINavigationController(rootViewController: searchViewController)
            let searchTabbarItem = RAMAnimatedTabBarItem(title: Strings.search, image: Asset.tabIconSearchNormal.image.tinted(color: .lightGray), selectedImage: Asset.mcflySearchNormal.image)
            searchTabbarItem.animation = RAMBounceAnimation()
            searchTabbarItem.animation.textSelectedColor = .white
            searchNavController.tabBarItem = searchTabbarItem
            
            let newMoviesViewModel = NewMoviesViewModel()
            let newMoviesViewController = NewMoviesViewController.instantiate(withViewModel: newMoviesViewModel)
            let newMoviesNavController = UINavigationController(rootViewController: newMoviesViewController)
            let newMoviesTabbarItem = RAMAnimatedTabBarItem(title: Strings.comingSoon, image: Asset.extrasCardsIconNormal.image.tinted(color: .lightGray), selectedImage: Asset.extrasCardsIconNormal.image)
            newMoviesTabbarItem.animation = RAMBounceAnimation()
            newMoviesTabbarItem.animation.textSelectedColor = .white
            newMoviesNavController.tabBarItem = newMoviesTabbarItem
            
            let myListViewModel = MyListViewModel()
            let myListViewController = MyListViewController.instantiate(withViewModel: myListViewModel)
            let myListNavController = UINavigationController(rootViewController: myListViewController)
            let myListTabbarItem = RAMAnimatedTabBarItem(title: Strings.myList, image: Asset.icMylistNormal.image.tinted(color: .lightGray), selectedImage: Asset.icMylistNormal.image)
            myListTabbarItem.animation = RAMBounceAnimation()
            myListTabbarItem.animation.textSelectedColor = .white
            myListNavController.tabBarItem = myListTabbarItem
            
            let moreViewModel = MoreViewModel()
            let moreViewController = MoreViewController.instantiate(withViewModel: moreViewModel)
            let moreNavController = UINavigationController(rootViewController: moreViewController)
            let moreTabbarItem = RAMAnimatedTabBarItem(title: Strings.more, image: Asset.mcflyMoreNormal.image.tinted(color: .lightGray), selectedImage: Asset.mcflyMoreNormal.image)
            moreTabbarItem.animation = RAMBounceAnimation()
            moreTabbarItem.animation.textSelectedColor = .white
            moreNavController.tabBarItem = moreTabbarItem
            
            rootTabbarController.setViewControllers([homeNavController, searchNavController, newMoviesNavController, myListNavController, moreNavController], animated: true)
            return .tabBar(rootTabbarController)
        }
    }
}
