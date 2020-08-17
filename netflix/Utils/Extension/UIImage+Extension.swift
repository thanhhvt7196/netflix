//
//  UIImage+Extension.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
}

extension UIImage {
//    func convertImageToBW(image:UIImage) -> UIImage {
//        let filter = CIFilter(name: "CIPhotoEffectMono")
//
//        // convert UIImage to CIImage and set as input
//
//        let ciInput = CIImage(image: image)
//        filter?.setValue(ciInput, forKey: "inputImage")
//
//        // get output CIImage, render as CGImage first to retain proper UIImage scale
//
//        let ciOutput = filter?.outputImage
//        let ciContext = CIContext()
//        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
//
//        return UIImage(cgImage: cgImage!)
//    }
}
