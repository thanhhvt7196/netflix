//
//  MoreViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class MoreViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: MoreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func prepareUI() {
        configNavigationBar()
    }
}

extension MoreViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
