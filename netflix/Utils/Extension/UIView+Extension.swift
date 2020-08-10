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
        blurredView.applyGradient(colors: [UIColor.clear.cgColor, UIColor.black.cgColor], locations: [0.0, 1.0])
        addSubview(blurredView)
        sendSubviewToBack(blurredView)
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
    
    func applyGradient(colors: [CGColor], locations: [NSNumber]?) {
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = locations
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
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

extension UIView {
    func dismissWithAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
            completion?()
        }
    }
}

extension UIView {
    func addSubViewWithAnimation(view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        addSubview(view)
    }
}
