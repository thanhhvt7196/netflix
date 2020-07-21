//
//  UITextfield+Extension.swift
//  myNews
//
//  Created by kennyS on 2/2/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import UIKit

extension UITextField{
    func setLeftImage(imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height))
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
}
