//
//  PersistentManager.swift
//  netflix
//
//  Created by thanh tien on 7/23/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

enum UserDefaultKeys {
    static let categoryType = "CategoryType"
}


class PersistentManager {
    static let shared = PersistentManager()
    private let defaults = UserDefaults.standard
    
    var categoryType: CategoryType {
        set {
            defaults.set(newValue.rawValue, forKey: UserDefaultKeys.categoryType)
        }
        get {
            if let typeValue = defaults.string(forKey: UserDefaultKeys.categoryType),
                let categoryType = CategoryType(rawValue: typeValue) {
                return categoryType
            } else {
                return .home
            }
        }
    }
    
    func clearWhenExit() {
        categoryType = .home
    }
}
