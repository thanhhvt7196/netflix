//
//  UIViewController+Extension.swift
//  myNews
//
//  Created by kennyS on 3/27/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizerDelegate where Self: UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func getTabbarHeight() -> CGFloat {
        if let controller = self.tabBarController {
            if #available(iOS 11, *), let keyWindow = UIApplication.shared.keyWindow {
                return controller.tabBar.frame.height - keyWindow.safeAreaInsets.bottom
            } else {
                return controller.tabBar.frame.height
            }
        }
        if let navController = self.navigationController, let tabbarController = navController.tabBarController {
            if #available(iOS 11, *), let keyWindow = UIApplication.shared.keyWindow {
                return tabbarController.tabBar.frame.height - keyWindow.safeAreaInsets.bottom
            } else {
                return tabbarController.tabBar.frame.height
            }
        }
        return 0
    }
}

extension UIViewController {
    enum SelectCase {
        case confirm
        case cancel
    }
    
    func showErrorAlert(title: String? = nil, message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String? = nil, message: String, actionTitle: String = "OK", completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: { _ in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmMessage(title: String, message: String, confirmTitle: String = "OK", cancelTitle: String = "Cancel", completion: @escaping(SelectCase) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle,
                                      style: .default,
                                      handler: { _ in completion(.confirm) }))
        alert.addAction(UIAlertAction(title: cancelTitle,
                                      style: .cancel,
                                      handler: { _ in completion(.cancel) }))
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func prepareView() {
        _ = view
    }
}
