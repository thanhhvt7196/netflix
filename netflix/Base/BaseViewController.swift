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

class BaseViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareUI() {
        navigationController?.navigationBar.barStyle = .black
    }
}
