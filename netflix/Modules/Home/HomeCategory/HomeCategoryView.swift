//
//  HomeCategoryView.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class HomeCategoryView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeCategoryViewModel!
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Void>()
    
    init(viewModel: HomeCategoryViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
        prepareUI()
        bind()
        handleAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func prepareUI() {
        configTableView()
    }
    
    private func bind() {
        let input = HomeCategoryViewModel.Input(fetchDataTrigger: fetchDataTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.nowPlayingList
            .drive(onNext: { lists in
                print(lists.map { $0.voteCount})
            })
            .disposed(by: bag)
        
    }
    
    private func handleAction() {
        
    }
}

extension HomeCategoryView {
    private func configTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.backgroundColor = .clear
    }
}

extension HomeCategoryView {
    func loadData() {
        fetchDataTrigger.onNext(())
    }
}
