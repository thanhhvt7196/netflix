//
//  NewMoviesViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class NewMoviesViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: NewMoviesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func prepareUI() {
        configNavigationBar()
    }
}

extension NewMoviesViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
