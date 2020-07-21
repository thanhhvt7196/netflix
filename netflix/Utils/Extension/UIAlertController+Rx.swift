//
//  UIAlertController+Rx.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIAlertController {
    
    var title: Binder<String> {
        return Binder(base) { alertController, title in
            alertController.title = title
        }
    }
    
    var message: Binder<String> {
        return Binder(base) { alertController, message in
            alertController.message = message
        }
    }
}
