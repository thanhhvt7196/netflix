//
//  GradientView.swift
//  netflix
//
//  Created by thanh tien on 7/23/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor
        ]
        backgroundColor = UIColor.clear
    }
}
