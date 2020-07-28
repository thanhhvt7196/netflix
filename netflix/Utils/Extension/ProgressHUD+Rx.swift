//
//  ProgressHUD+Rx.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: ProgressHUD {
    static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
            isVisible ? ProgressHUD.shared.show() : ProgressHUD.shared.hide()
        }
    }
}
