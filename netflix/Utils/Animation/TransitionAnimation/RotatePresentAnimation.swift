//
//  RotatePresentAnimation.swift
//  netflix
//
//  Created by thanh tien on 9/3/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class RotatePresentAnimation: CustomAnimator {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.addSubview(toView)
//        toView.alpha = 0
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            fromView.alpha = 0
//            toView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
