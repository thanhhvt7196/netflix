//
//  ArrowDownButton.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ArrowDownButton: UIView {
    let selectButton = UIButton()
    private let titleLabel = UILabel()
    private let dropdownIcon = UIImageView()
    private let stackView = UIStackView()
    
    convenience init(title: String) {
        self.init()
        setTitle(title: title)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    var showDropdown = false {
        didSet {
            dropdownIcon.isHidden = !showDropdown
        }
    }
    
    private func commonInit() {
        setupStackView()
        addSelectButton()
        setupTitleLabel()
        setupDropdownIcon()

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dropdownIcon)
        dropdownIcon.isHidden = true
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 13)
    }
    
    private func setupDropdownIcon() {
        dropdownIcon.image = Asset.iconDropdownNormal.image
        dropdownIcon.contentMode = .scaleAspectFit
        dropdownIcon.translatesAutoresizingMaskIntoConstraints = false
        dropdownIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dropdownIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
    }
    
    private func addSelectButton() {
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectButton)
        selectButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        selectButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        selectButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bringSubviewToFront(selectButton)
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

extension Reactive where Base: ArrowDownButton {
    var tap: ControlEvent<Void> {
        return base.selectButton.rx.tap
    }
}
