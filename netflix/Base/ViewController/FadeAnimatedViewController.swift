//
//  BaseController.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class FadeAnimatedViewController: BaseViewController {
    override func prepareUI() {
        super.prepareUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
