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
