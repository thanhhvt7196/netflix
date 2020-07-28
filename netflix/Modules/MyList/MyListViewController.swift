//
//  MyListViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class MyListViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: MyListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareUI() {
        configNavigationBar()
    }
}

extension MyListViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
