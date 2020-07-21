//
//  UIBarButtonItem+Rx.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    var image: Binder<UIImage> {
        return Binder(base) { button, image in
            button.image = image
        }
    }
}
