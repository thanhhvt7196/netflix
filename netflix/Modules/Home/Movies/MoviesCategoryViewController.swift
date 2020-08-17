//
//  MoviesCategoryViewController.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

class MoviesCategoryViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MoviesCategoryViewModel!
    
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Int?>()
    private let clearDataTrigger = PublishSubject<Void>()
    private var dataSources: RxTableViewSectionedReloadDataSource<HomeCategoryViewSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObserver()
        bind()
        handleAction()
    }
    
    deinit {
        removeObserver()
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeaderMovieStatus(notification:)), name: .didAddToMyList, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareUI() {
        super.prepareUI()
        configTableView()
        setupDataSources()
    }
    
    private func bind() {
        let input = MoviesCategoryViewModel.Input(
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
        .flatMapLatest { cell -> Observable<Media> in
            return .just(cell.viewModel.movie)
        }
        .subscribe(onNext: { movie in
            SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: movie))
        })
            .disposed(by: bag)
    }
}

extension MoviesCategoryViewController {
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
            case .previewList(let movies, let mediaType):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomeNowPlayingCell
                let nowPlayingViewModel = HomeNowPlayingCellViewModel(movies: movies, mediaType: mediaType)
                cell.bindViewModel(viewModel: nowPlayingViewModel)
                return cell
            case .moviesListItem(let movies, let mediaType):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MovieListTableViewCell
                let movieListCellViewModel = MovieListCellViewModel(movies: movies, mediaType: mediaType)
                cell.bindViewModel(viewModel: movieListCellViewModel)
                return cell
            }
        })
    }
}

extension MoviesCategoryViewController {
    func loadData(genreID: Int?) {
        clearDataTrigger.onNext(())
        fetchDataTrigger.onNext(genreID)
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

extension MoviesCategoryViewController: UITableViewDelegate {
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

