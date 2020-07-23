//
//  ChooseCategoryTypeView.swift
//  netflix
//
//  Created by thanh tien on 7/23/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class ChooseCategoryTypeView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: ChooseCategoryTypeViewModel!
    let selectedCategoryType = PublishSubject<CategoryType>()
    
    private let bag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(viewModel: ChooseCategoryTypeViewModel, frame: CGRect) {
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
    
    private func prepareUI() {
        containerView.blur(withStyle: .dark)
        configTableView()
        configCloseButton()
    }
    
    private func bind() {
        let input = ChooseCategoryTypeViewModel.Input(selectedItem: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.categoryTypes
            .drive(tableView.rx.items) { tableView, row, type in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomeCategoryTypeCell
                cell.configCell(type: type)
                return cell
            }
            .disposed(by: bag)
        
        output.selectedCategoryType.drive(selectedCategoryType).disposed(by: bag)
    }
    
    private func handleAction() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismissWithAnimation()
            })
            .disposed(by: bag)
    }
    
    private func configCloseButton() {
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = closeButton.bounds.height/2
    }
    
    private func configTableView() {
        tableView.bounces = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        tableView.backgroundColor = .clear
        tableView.rowHeight = 60
        tableView.register(cellType: HomeCategoryTypeCell.self)
    }
}
