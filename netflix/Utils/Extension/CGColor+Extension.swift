//
//  CGColor+Extension.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    var gradientLayer = CAGradientLayer()
    
    init() {
        let colorTop = UIColor.black
        let colorBottom = UIColor.white
        self.gradientLayer.colors = [colorTop, colorBottom]
        self.gradientLayer.locations = [0.0, 1.0]
    }
}
