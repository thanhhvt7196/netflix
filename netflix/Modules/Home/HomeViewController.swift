//
//  HomeViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: HomeViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        bind()
    }
    
    private func prepareUI() {
        configNavigationBar()
    }
    
    private func bind() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete()
        let input = HomeViewModel.Input(fetchTrigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.fetchResult
            .drive(onNext: { movies in
                print(movies.map { $0.originalTitle })
            })
            .disposed(by: bag)
        
        output.indicator.drive(ProgressHelper.rx.isAnimating).disposed(by: bag)
    }
}

extension HomeViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
