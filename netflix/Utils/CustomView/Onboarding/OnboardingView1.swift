//
//  OnboardingView.swift
//  netflix
//
//  Created by thanh tien on 7/28/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import UIKit

class OnboardingView1: UIView, NibOwnerLoadable {
    private func commonInit() {
        loadNibContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
