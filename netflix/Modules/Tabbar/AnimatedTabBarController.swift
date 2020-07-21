//
//  RootTabbarController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable

class AnimatedTabBarController: UITabBarController, StoryboardBased {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    
    private func prepareUI() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
    }
}
