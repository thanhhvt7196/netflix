//
//  SystemPopAnimator.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit

class SystemPopAnimator: CustomAnimator {
    init(type: TransitionType,
                duration: TimeInterval = 0.25,
                interactionController: UIPercentDrivenInteractiveTransition? = nil) {
        super.init(type: type, duration: duration)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        if self.type == .navigation {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        let animations = {
            fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0)
            toViewController.view.frame = containerView.bounds
        }
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseOut],
            animations: animations) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
