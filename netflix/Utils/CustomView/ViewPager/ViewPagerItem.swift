//
//  ViewPagerItem.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class ViewPagerItem: UIView {
    private var titleLabel = UILabel()
    private let padding: CGFloat = 0
    
    convenience init(title: String) {
        self.init()
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        configLayout()
        configLabel()
    }
}

extension ViewPagerItem {
    var tabWidth: CGFloat {
        return (2 * padding) + titleLabel.intrinsicContentSize.width
    }
}

extension ViewPagerItem {
    @discardableResult
    func set(backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func set(textColor: UIColor) -> Self {
        self.titleLabel.textColor = textColor
        return self
    }
    
    @discardableResult
    func set(font: UIFont) -> Self {
        self.titleLabel.font = font
        return self
    }
    
    @discardableResult
    func set(title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
}

extension ViewPagerItem {
    private func configLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func configLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
    }
}

extension ViewPagerItem {
    func addHighlight(backgroundColor: UIColor, textColor: UIColor) {
        guard !isHighlight(backgroundColor: backgroundColor, textColor: textColor) else {
            return
        }
        set(backgroundColor: backgroundColor).set(textColor: textColor)
    }
    
    func removeHighlight(backgroundColor: UIColor, textColor: UIColor) {
        guard isHighlight(backgroundColor: backgroundColor, textColor: textColor) else { return }
        set(backgroundColor: backgroundColor).set(textColor: textColor)
    }
    
    private func isHighlight(backgroundColor: UIColor, textColor: UIColor) -> Bool {
        return self.backgroundColor == backgroundColor
                && titleLabel.textColor == textColor
    }
}
