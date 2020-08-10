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
    private let clearDataTrigger = PublishSubject<Void>()
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
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        createObserver()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: window)
        removeObserver()
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeaderMovieStatus(notification:)), name: .didAddToMyList, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareUI() {
        configTableView()
        setupDataSources()
    }
    
    private func bind() {
        let input = HomeCategoryViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asDriverOnErrorJustComplete(),
            clearDataTrigger: clearDataTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.error
            .drive(onNext: { error in
                print("Error blahblah = \(error)")
            })
            .disposed(by: bag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSources))
            .disposed(by: bag)
        
        output.indicator.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
    
    private func handleAction() {
        tableView.rx.itemSelected
            .flatMapLatest { [weak self] indexPath -> Observable<HeaderMovieTableViewCell> in
                guard let self = self, let cell = self.tableView.cellForRow(at: indexPath) as? HeaderMovieTableViewCell else {
                    return .empty()
                }
                return .just(cell)
            }
            .flatMapLatest { cell -> Observable<Movie> in
                return .just(cell.viewModel.movie)
            }
            .subscribe(onNext: { movie in
                SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: movie))
            })
            .disposed(by: bag)
    }
}

extension HomeCategoryView {
    private func configTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.register(cellType: HeaderMovieTableViewCell.self)
        tableView.register(cellType: HomeNowPlayingCell.self)
        tableView.register(cellType: MovieListTableViewCell.self)
    }
    
    private func setupDataSources() {
        dataSources = RxTableViewSectionedReloadDataSource(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch dataSource[indexPath] {
            case .headerMovie(let movie):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderMovieTableViewCell
                let viewModel = HeaderMovieViewModel(movie: movie, mediaType: .movie)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            case .previewList(let movies):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomeNowPlayingCell
                let nowPlayingViewModel = HomeNowPlayingCellViewModel(movies: movies)
                cell.bindViewModel(viewModel: nowPlayingViewModel)
                return cell
            case .moviesListItem(let movies):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MovieListTableViewCell
                let movieListCellViewModel = MovieListCellViewModel(movies: movies)
                cell.bindViewModel(viewModel: movieListCellViewModel)
                return cell
            }
        })
    }
}

extension HomeCategoryView {
    func loadData() {
        clearDataTrigger.onNext(())
        fetchDataTrigger.onNext(())
        print(PersistentManager.shared.watchList.count)
    }
    
    @objc private func updateHeaderMovieStatus(notification: Notification) {
        if let userInfo = notification.userInfo,
            let isMyList = userInfo["is_mylist"] as? Bool,
            let movieID = userInfo["movie_id"] as? Int {
            guard let indexPaths = tableView.indexPathsForVisibleRows else {
                return
            }
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? HeaderMovieTableViewCell {
                    cell.update(isMyList: isMyList, movieID: movieID)
                }
            }
        }
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
        return viewModel.dataSource.value[section].title.isNilOrEmpty ? .leastNonzeroMagnitude : 40
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
