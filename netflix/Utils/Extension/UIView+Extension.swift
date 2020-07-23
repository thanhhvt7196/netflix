//
//  UIView+Extension.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var borderColor: CGColor? {
        get {
            return layer.borderColor
        }
        set {
            layer.borderColor = newValue
        }
    }

    var borderWidth: Double {
        get {
            return Double(layer.borderWidth)
        }
        set {
            layer.borderWidth = CGFloat(newValue)
        }
    }

    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = bounds
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredView)
        clipsToBounds = true
    }

    func dim(withAlpha alpha: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let coverLayer = CALayer()
            coverLayer.frame = self.bounds
            coverLayer.backgroundColor = UIColor.black.cgColor
            coverLayer.opacity = Float(alpha)
            self.layer.addSublayer(coverLayer)
        }
    }

    func roundCorners(_ corners: UIRectCorner = .allCorners, withRadius radius: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.3
        self.addSubview(blurEffectView)
    }
}

extension UIView {
    func deactiveWidthConstraints() {
        let widthConstraints = constraints.filter { $0.firstAttribute == .width }
        NSLayoutConstraint.deactivate(widthConstraints)
    }
    
    func deactiveHeightConstraints() {
        let heightConstraints = constraints.filter { $0.firstAttribute == .height }
        NSLayoutConstraint.deactivate(heightConstraints)
    }
    
    func deactiveTopConstraints() {
        let topConstraints = constraints.filter { $0.firstAttribute == .top }
        NSLayoutConstraint.deactivate(topConstraints)
    }
    
    func deactiveBottomConstraints() {
        let bottomConstraints = constraints.filter { $0.firstAttribute == .bottom }
        NSLayoutConstraint.deactivate(bottomConstraints)
    }
    
    func deactiveLeadingConstraints() {
        let leadingConstraints = constraints.filter { $0.firstAttribute == .leading }
        NSLayoutConstraint.deactivate(leadingConstraints)
    }
    
    func deactiveTrailingConstraints() {
        let trailingConstraints = constraints.filter { $0.firstAttribute == .trailing }
        NSLayoutConstraint.deactivate(trailingConstraints)
    }
}
