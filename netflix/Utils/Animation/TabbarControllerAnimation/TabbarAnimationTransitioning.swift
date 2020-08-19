//
//  TabbarAnimationTransitioning.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: .to)
//            let source = transitionContext.view(forKey: .from)
            else {
                return
        }

        destination.alpha = 0.0
//        destination.transform = CGAffineTransform(translationX: 100, y: 0)
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
//            source.alpha = 0
//            destination.transform = .identity
        }, completion: {
//            source.alpha = 1
            transitionContext.completeTransition($0)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }

}
