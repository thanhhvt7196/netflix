//
//  ChooseCategoryView.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class ChooseCategoryView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: ChooseCategoryViewModel!
    let selectedGenre = PublishSubject<Genre>()
    
    private let bag = DisposeBag()
    
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
    
    init(viewModel: ChooseCategoryViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        commonInit()
    }
    
    private func prepareUI() {
        containerView.blur(withStyle: .dark)
        configTableView()
        configCloseButton()
    }
    
    private func bind() {
        let input = ChooseCategoryViewModel.Input(selectedItem: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.genreList
            .drive(tableView.rx.items) { tableView, row, genre in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomeChooseCategoryCell
                cell.configCell(genre: genre)
                return cell
            }
            .disposed(by: bag)
        
        output.selectedGenre.drive(selectedGenre).disposed(by: bag)
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
        tableView.register(cellType: HomeChooseCategoryCell.self)
    }
}
