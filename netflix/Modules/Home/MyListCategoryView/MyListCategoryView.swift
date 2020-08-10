//
//  MyListCategoryView.swift
//  netflix
//
//  Created by thanh tien on 8/9/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reusable
import UIKit

class MyListCategoryView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MyListCategoryViewModel!
    
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Void>()
    private let clearDataTrigger = PublishSubject<Void>()
    
    init(viewModel: MyListCategoryViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
        prepareUI()
        bind()
//        handleAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func prepareUI() {
//        configTableView()
//        setupDataSources()
    }
    
    private func bind() {
        let input = MyListCategoryViewModel.Input(
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
//        
//        output.dataSource
//            .bind(to: tableView.rx.items(dataSource: dataSources))
//            .disposed(by: bag)
//        
//        output.indicator.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
}

extension MyListCategoryView {
    func loadData() {
        clearDataTrigger.onNext(())
        fetchDataTrigger.onNext(())
    }
}
