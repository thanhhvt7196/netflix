//
//  TVShowCategoryViewController.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class TVShowCategoryViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TVShowCategoryViewModel!
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
        let input = TVShowCategoryViewModel.Input(
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
        .flatMapLatest { cell -> Observable<Media> in
            return .just(cell.viewModel.movie)
        }
        .subscribe(onNext: { movie in
            SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: movie))
        })
            .disposed(by: bag)
    }
}

extension TVShowCategoryViewController {
    private func configTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.register(cellType: HeaderMovieTableViewCell.self)
        tableView.register(cellType: HomePreviewListCell.self)
        tableView.register(cellType: MovieListTableViewCell.self)
    }
    
    private func setupDataSources() {
        dataSources = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            switch dataSource[indexPath] {
            case .headerMovie(let movie):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderMovieTableViewCell
                let viewModel = HeaderMovieViewModel(movie: movie, mediaType: .tv)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            case .previewList(let movies, let mediaType):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomePreviewListCell
                let previewListViewModel = HomePreviewListCellViewModel(medias: movies, mediaType: mediaType, indexPath: indexPath)
                cell.delegate = self
                cell.bindViewModel(viewModel: previewListViewModel, contentOffset: self.viewModel.rowContentOffSets[indexPath] ?? .zero)
                return cell
            case .moviesListItem(let movies, let mediaType):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MovieListTableViewCell
                let movieListCellViewModel = MovieListCellViewModel(medias: movies, mediaType: mediaType, indexPath: indexPath)
                cell.delegate = self
                cell.bindViewModel(viewModel: movieListCellViewModel, contentOffset: self.viewModel.rowContentOffSets[indexPath] ?? .zero)
                return cell
            }
        })
    }
}

extension TVShowCategoryViewController {
    func loadData(genreID: Int?) {
        clearData()
        fetchDataTrigger.onNext(genreID)
    }
    
    private func clearData() {
        clearDataTrigger.onNext(())
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

extension TVShowCategoryViewController: UITableViewDelegate {
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

extension TVShowCategoryViewController: ListCellDelegate {
    func collectionViewDidScroll(contentOffset: CGPoint, indexPath: IndexPath) {
        viewModel.rowContentOffSets[indexPath] = contentOffset
    }
}
