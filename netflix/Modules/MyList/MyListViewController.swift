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

class MyListViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    var viewModel: MyListViewModel!
    
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Void>()
    private let clearDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func prepareUI() {
        super.prepareUI()
    }
    
    private func bind() {
        let input = MyListViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asDriverOnErrorJustComplete(),
            clearDataTrigger: clearDataTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.mylist
            .drive(onNext: { mylist in
                print("mylist count = \(mylist.count)")
            })
            .disposed(by: bag)
        
        //        output.error
        //            .drive(onNext: { error in
        //                print("Error blahblah = \(error)")
        //            })
        //            .disposed(by: bag)
    }
}

extension MyListViewController {
    func loadData() {
        clearDataTrigger.onNext(())
        fetchDataTrigger.onNext(())
    }
}
