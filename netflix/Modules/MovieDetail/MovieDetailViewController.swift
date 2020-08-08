//
//  MovieDetailViewController.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class MovieDetailViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    var viewModel: MovieDetailViewModel!
    private let bag = DisposeBag()
    
    private let getMovieDetailTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
        getMovieDetail()
    }
    
    override func prepareUI() {
        super.prepareUI()
    }
    
    private func bind() {
        let input = MovieDetailViewModel.Input(getMovieDetailTrigger: getMovieDetailTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
    }
    
    private func handleAction() {
        
    }
}


extension MovieDetailViewController {
    private func getMovieDetail() {
        getMovieDetailTrigger.onNext(())
    }
}
