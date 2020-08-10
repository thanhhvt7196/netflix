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
    fileprivate let selectButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let dropdownIcon = UIImageView()
    private let stackView = UIStackView()
    
    convenience init(title: String) {
        self.init()
        setTitle(title: title)
    }
    
    func setTitle(title: String) {
        UIView.transition(with: titleLabel,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.titleLabel.text = title
        }, completion: nil)
    }
    
    var transformIcon = false {
        didSet {
            if transformIcon {
                dropdownIcon.transform = .identity
            } else {
                dropdownIcon.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
        }
    }
    
    var scale = false {
        didSet {
            if scale {
                let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.titleLabel.transform = transform
                stackView.spacing = 5
            } else {
                self.titleLabel.transform = .identity
                stackView.spacing = 0
            }
        }
    }
    
    var fontSize: CGFloat = 13 {
        didSet {
            titleLabel.font = .systemFont(ofSize: fontSize)
        }
    }
    
    private func commonInit() {
        setupStackView()
        addSelectButton()
        setupTitleLabel()
        setupDropdownIcon()

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dropdownIcon)
        dropdownIcon.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: fontSize)
    }
    
    private func setupDropdownIcon() {
        dropdownIcon.image = Asset.iconDropdownNormal.image
        dropdownIcon.contentMode = .scaleAspectFit
        dropdownIcon.translatesAutoresizingMaskIntoConstraints = false
        dropdownIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        dropdownIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
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

extension ArrowDownButton {
    func addTarget(target: Any?, selector: Selector) {
        selectButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}

extension Reactive where Base: ArrowDownButton {
    var tap: ControlEvent<Void> {
        return base.selectButton.rx.tap
    }
    
    var title: Binder<String> {
        return Binder(base) { arrowDownButton, title in
            arrowDownButton.setTitle(title: title)
        }
    }
}
