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
            let homeTabbarItem = RAMAnimatedTabBarItem(title: "Home", image: nil, selectedImage: nil)
            homeTabbarItem.animation = RAMBounceAnimation()
            homeTabbarItem.animation.textSelectedColor = .themeOrange
            homeNavController.tabBarItem = homeTabbarItem
            
            rootTabbarController.setViewControllers([homeNavController], animated: true)
            return .tabBar(rootTabbarController)
        }
    }
}
