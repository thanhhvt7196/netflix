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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(colors: [CGColor]) {
        self.init()
        self.colors = colors
    }
    
    private func commonInit() {
        setLayerColors(colors: colors)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    var colors: [CGColor] = [
        UIColor.black.withAlphaComponent(0.5).cgColor,
        UIColor.clear.cgColor,
        UIColor.black.cgColor
        ] {
        didSet {
            setLayerColors(colors: colors)
        }
    }
    
    private func setLayerColors(colors: [CGColor]) {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        gradientLayer.colors = colors
        backgroundColor = UIColor.clear
    }
}
