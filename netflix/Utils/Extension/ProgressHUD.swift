//
//  ProgressHUD.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class ProgressHelper: NSObject {
    static let shared = ProgressHelper()
    
    private var backgroundView: UIView!
    private var activityIndicatorBackgroundView: UIView!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var isShowing = false
    
    private override init() {
        super.init()
        if backgroundView == nil {
            backgroundView = UIView()
            backgroundView.frame = UIScreen.main.bounds
            backgroundView.backgroundColor = .black
            backgroundView.layer.opacity = 0.2
        }
        if activityIndicatorBackgroundView == nil {
            activityIndicatorBackgroundView = UIView()
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
            activityIndicatorBackgroundView.center = backgroundView.center
            activityIndicatorBackgroundView.backgroundColor = .black
            activityIndicatorBackgroundView.layer.cornerRadius = 10
        }
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
            activityIndicatorView.center = activityIndicatorBackgroundView.center
        }
    }
    
    func show() {
        if !isShowing {
            isShowing = true
            activityIndicatorView.startAnimating()
            UIApplication.shared.keyWindow?.addSubview(backgroundView)
            UIApplication.shared.keyWindow?.addSubview(activityIndicatorBackgroundView)
            UIApplication.shared.keyWindow?.addSubview(activityIndicatorView)
        }
    }
    
    @objc func hide() {
        if isShowing {
            isShowing = false
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            activityIndicatorBackgroundView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
    
    func updateProgressView() {
        backgroundView.frame = UIScreen.main.bounds
        activityIndicatorBackgroundView.center = backgroundView.center
        activityIndicatorView.center = activityIndicatorBackgroundView.center
        backgroundView.layoutIfNeeded()
        activityIndicatorBackgroundView.layoutIfNeeded()
        activityIndicatorView.layoutIfNeeded()
    }
}
