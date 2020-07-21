//
//  UIImageView+Rx.swift
//  myNews
//
//  Created by kennyS on 3/27/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SDWebImage

extension Reactive where Base: UIImageView {
    var imageURL: Binder<URL> {
        return Binder(base) { imageView, url in
            imageView.sd_imageTransition = .fade
            imageView.sd_setImage(with: url)
        }
    }
}
