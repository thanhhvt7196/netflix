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
    var imageURL: Binder<URL?> {
        return Binder(base) { imageView, url in
            imageView.sd_imageTransition = .fade
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: url, placeholderImage: UIColor.black.toImage()) { (image, error, _, url) in
                if error != nil {
                    imageView.image = UIImage(named: "No-Photo-Available")
                }
            }
        }
    }
    
    func imageURL(placeHolder: UIImage? = UIColor.black.toImage(), blur: Bool = false) -> Binder<URL?> {
        return Binder(base) { imageView, url in
            imageView.sd_imageTransition = .fade
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let transformer = SDImageBlurTransformer(radius: 100)
            let context: [SDWebImageContextOption: Any]? = blur ? [.imageTransformer: transformer] : nil
            imageView.sd_setImage(with: url, placeholderImage: nil, context: context, progress: nil) { (image, error, _, url) in
                if error != nil {
                    imageView.image = placeHolder
                }
            }
        }
    }
}
