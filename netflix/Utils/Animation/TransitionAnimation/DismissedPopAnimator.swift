//
//  FadePopAnimator.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class DismissedPopAnimator: CustomAnimator {
    
    init(type: TransitionType,
                duration: TimeInterval = 0.22,
                interactionController: UIPercentDrivenInteractiveTransition? = nil) {
        super.init(type: type, duration: duration)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
            else {
                return
        }
        
        if type == .navigation, let toViewController = transitionContext.viewController(forKey: .to) {
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }

        let duration = transitionDuration(using: transitionContext)
        if let movieDetailViewController = fromViewController as? MovieDetailViewController, movieDetailViewController.tableView.contentOffset.y <= movieDetailViewController.offSetToPopToRoot {
            movieDetailViewController.tableView.setContentOffset(.zero, animated: false)
            movieDetailViewController.clearData()
            UIView.animate(withDuration: duration, animations: {
                let frame = movieDetailViewController.view.frame
                movieDetailViewController.view.frame.origin.y = frame.height
                movieDetailViewController.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                fromViewController.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}


