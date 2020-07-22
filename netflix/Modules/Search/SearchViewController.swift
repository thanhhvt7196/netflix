//
//  SearchViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        configNavigationBar()
    }
}

extension SearchViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
