//
//  UIImageView+Extension.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func blurImage() {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur"),
            let cropFilter = CIFilter(name: "CICrop"),
            let image = image
        else {
            return
        }
        let context = CIContext(options: nil)

        guard let beginImage = CIImage(image: image) else { return }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(100, forKey: kCIInputRadiusKey)

        
        cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")

        guard let output = cropFilter.outputImage,
            let cgimg = context.createCGImage(output, from: output.extent)
        else {
            return
        }
        
        let processedImage = UIImage(cgImage: cgimg)
        self.image = processedImage
    }
}
