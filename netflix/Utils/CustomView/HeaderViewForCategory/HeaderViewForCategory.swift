//
//  HeaderViewForCategory.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable

class HeaderViewForCategory: UIView, NibOwnerLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    
    convenience init(title: String, frame: CGRect) {
        self.init(frame: frame)
        titleLabel.text = title
    }
    
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
