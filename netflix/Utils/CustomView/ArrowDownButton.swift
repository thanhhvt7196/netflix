//
//  ArrowDownButton.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class ArrowDownButton: UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
    }
    
    var showDropDown = false {
        didSet {
            setImage(showDropDown ? Asset.iconDropdownNormal.image : nil, for: .normal)
        }
    }
    
    private func commonInit() {
        semanticContentAttribute = .forceRightToLeft
        contentMode = .center
        imageView?.contentMode = .scaleAspectFit
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13)
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
