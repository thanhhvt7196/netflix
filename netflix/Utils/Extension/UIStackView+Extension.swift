//
//  UIStackView+Extension.swift
//  myNews
//
//  Created by kennyS on 4/18/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        while arrangedSubviews.count > 0 {
            arrangedSubviews.first?.removeFromSuperview()
        }
    }
}
