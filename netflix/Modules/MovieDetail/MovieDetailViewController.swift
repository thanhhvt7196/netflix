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
import RxDataSources

class MovieDetailViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MovieDetailViewModel!
    private let bag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<MovieDetailSectionModel>!
    
    private let getMovieDetailTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
        getMovieDetail()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configTableView()
        setupDataSource()
    }
    
    private func bind() {
        let input = MovieDetailViewModel.Input(getMovieDetailTrigger: getMovieDetailTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
//        output.movie
//            .drive(onNext: { detail in
//                print("detail")
//            })
//            .disposed(by: bag)
        
        output.loading.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func handleAction() {
        
    }
}

extension MovieDetailViewController {
    private func configTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.register(cellType: HeaderMovieDetailCell.self)
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<MovieDetailSectionModel>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            switch dataSource[indexPath] {
            case .headerMovie(let media, let detail):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderMovieDetailCell
                let viewModel = HeaderMovieDetailViewModel(media: media, detail: detail)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            default:
                return UITableViewCell()
            }
        })
    }
}

extension MovieDetailViewController {
    private func getMovieDetail() {
        getMovieDetailTrigger.onNext(())
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
