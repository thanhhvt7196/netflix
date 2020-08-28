//
//  ListCellDelegate.swift
//  netflix
//
//  Created by thanh tien on 8/28/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

protocol ListCellDelegate: class {
    func collectionViewDidScroll(contentOffset: CGPoint, indexPath: IndexPath)
}
