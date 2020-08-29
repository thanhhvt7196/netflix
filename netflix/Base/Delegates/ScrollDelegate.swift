//
//  ScrollDelegate.swift
//  netflix
//
//  Created by thanh tien on 8/29/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ScrollDelegate: class {
    @objc optional func didScroll(scrollView: UIScrollView)
    @objc optional func willBeginDragging(scrollView: UIScrollView)
    @objc optional func didEndDragging(scrollView: UIScrollView)
}
