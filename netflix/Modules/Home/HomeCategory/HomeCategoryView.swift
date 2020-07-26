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
    private var dataSources: RxTableViewSectionedReloadDataSource<HomeCategoryViewSectionModel>!
    
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
        setupDataSources()
    }
    
    private func bind() {
        let input = HomeCategoryViewModel.Input(fetchDataTrigger: fetchDataTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.error
            .drive(onNext: { error in
                print(error)
            })
            .disposed(by: bag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSources))
            .disposed(by: bag)
    }
    
    private func handleAction() {
        
    }
}

extension HomeCategoryView {
    private func configTableView() {
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.backgroundColor = .clear
        tableView.register(cellType: HeaderMovieTableViewCell.self)
    }
    
    private func setupDataSources() {
        dataSources = RxTableViewSectionedReloadDataSource(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch dataSource[indexPath] {
            case .movieItem(let movie):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderMovieTableViewCell
                let viewModel = HeaderMovieViewModel(movie: movie)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = .black
                return cell
            }
        })
    }
}

extension HomeCategoryView {
    func loadData() {
        fetchDataTrigger.onNext(())
    }
}

extension HomeCategoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.dataSource.value.indices.contains(section) else {
            return .leastNonzeroMagnitude
        }
        return viewModel.dataSource.value[section].title == nil ? .leastNonzeroMagnitude : 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.dataSource.value.indices.contains(section) else {
            return nil
        }
        if let title = viewModel.dataSource.value[section].title {
            return HeaderViewForCategory(title: title, frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        } else {
            return nil
        }
    }
}
