//
//  HomeCategoryViewController.swift
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

class HomeCategoryViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeCategoryViewModel!
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Void>()
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
            .drive(tableView.rx.items(dataSource: dataSources))
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
        .flatMapLatest { cell -> Observable<(Media, MediaType)> in
            return .just((cell.viewModel.movie, cell.viewModel.mediaType))
        }
        .subscribe(onNext: { movie, mediaType in
            switch mediaType {
            case .movie:
                SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: movie))
            case .tv:
                break
            }
        })
        .disposed(by: bag)
    }
}

extension HomeCategoryViewController {
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

extension HomeCategoryViewController {
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

extension HomeCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataSources = dataSources else {
            return .leastNonzeroMagnitude
        }
        switch dataSources[section] {
        case .headerMovie:
            return .leastNonzeroMagnitude
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataSources = dataSources else {
            return nil
        }
        switch dataSources[section] {
        case .headerMovie:
            return nil
        default:
            if let title = dataSources[section].title {
                return HeaderViewForCategory(title: title, frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            } else {
                return nil
            }
        }
    }
}

