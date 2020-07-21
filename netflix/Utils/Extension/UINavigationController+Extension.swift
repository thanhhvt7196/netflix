//
//  UINavigationController+Extension.swift
//  myNews
//
//  Created by kennyS on 4/3/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func checkCurrentViewController<T: UIViewController>(type: T.Type) -> T? {
        if let visibleViewController = visibleViewController as? T {
            return visibleViewController
        } else {
            return nil
        }
    }
}
