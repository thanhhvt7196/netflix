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
import JXSegmentedView

class MovieDetailViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeImageView: UIImageView!
    
    private let pagerHeaderView = PagerHeaderSectionView()
    
    var viewModel: MovieDetailViewModel!
    private let bag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<MovieDetailSectionModel>!
    
    private let defaultBlueViewHeight: CGFloat = 300
    let offSetToPopToRoot: CGFloat = -120
    private let offSetToHideCloseButton: CGFloat = -100
    
    private let getMovieDetailTrigger = PublishSubject<Void>()
    private let selectedContentIndex = BehaviorRelay<Int>(value: 0)
    private var isPoppedToRoot = false
    
    override func loadView() {
        super.loadView()
        blurViewHeightConstraint.constant = defaultBlueViewHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObserver()
        bind()
        handleAction()
        getMovieDetail()
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
        configButton()
        configTableView()
        configViewPager()
        setupDataSource()
    }
    
    private func bind() {
        let input = MovieDetailViewModel.Input(
            getMovieDetailTrigger: getMovieDetailTrigger.asDriverOnErrorJustComplete(),
            selectedContent: selectedContentIndex
        )
        let output = viewModel.transform(input: input)
            
        output.loading.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
        
        output.media
            .map { $0.posterPath }
            .map { ImageHelper.shared.pathToURL(path: $0, imageSize: .w500)}
            .drive(backgroundImageView.rx.imageURL(blur: true))
            .disposed(by: bag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func handleAction() {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                SceneCoordinator.shared.pop(animated: true, toRoot: false)
            })
            .disposed(by: bag)
    }
}

extension MovieDetailViewController {
    private func configButton() {
        closeView.layer.cornerRadius = closeView.bounds.height/2
    }
    
    private func configTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(cellType: RecommendationMediaCell.self)
        tableView.register(cellType: HeaderMovieDetailCell.self)
        tableView.register(cellType: MovieDetailVideoCell.self)
    }
    
    private func configViewPager() {
        pagerHeaderView.delegate = self
        pagerHeaderView.backgroundColor = .black
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<MovieDetailSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade),
            decideViewTransition: { _,_,_  in
                return .reload
            },
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch dataSource[indexPath] {
            case .headerMovie(let media, let detail):
                let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderMovieDetailCell
                let viewModel = HeaderMovieDetailViewModel(media: media, detail: detail)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            case .recommendMedia(let medias):
                let cell = tableView.dequeueReusableCell(for: indexPath) as RecommendationMediaCell
                let viewModel = RecommendationMediaCellViewModel(medias: medias, mediaType: .movie)
                cell.bindViewModel(viewModel: viewModel)
                return cell
            case .episode(let video):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MovieDetailVideoCell
                cell.configCell(video: video)
                return cell
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataSource = dataSource else {
            return .leastNonzeroMagnitude
        }
        switch dataSource[section] {
        case .content:
            return 40
        default:
            return .leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataSource = dataSource else {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        }
        switch dataSource[section] {
        case .content(let titles, _):
            pagerHeaderView.setTitles(titles: titles)
            return pagerHeaderView
        default:
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        blurViewHeightConstraint.constant = defaultBlueViewHeight - scrollView.contentOffset.y
        guard (scrollView as? UITableView) == tableView else {
            return
        }
        if tableView.contentOffset.y < 0 {
            let alpha = tableView.contentOffset.y / offSetToHideCloseButton
            closeImageView.alpha = 1 - alpha
            closeView.alpha = 1 - alpha
            closeButton.isEnabled = alpha < 1
        } else {
            closeImageView.alpha = 1
            closeView.alpha = 1
            closeButton.isEnabled = true
        }
        if !isPoppedToRoot && tableView.contentOffset.y <= offSetToPopToRoot {
            SceneCoordinator.shared.pop(animated: true, toRoot: true)
            isPoppedToRoot = true
        }
    }
}

extension MovieDetailViewController: PagerHeaderSectionViewDelegate {
    func itemSelected(at index: Int) {
        selectedContentIndex.accept(index)
    }
}

extension MovieDetailViewController {
    @objc private func updateHeaderMovieStatus(notification: Notification) {
        if let userInfo = notification.userInfo,
            let isMyList = userInfo["is_mylist"] as? Bool,
            let movieID = userInfo["movie_id"] as? Int {
            guard let indexPaths = tableView.indexPathsForVisibleRows else {
                return
            }
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? HeaderMovieDetailCell {
                    cell.update(isMyList: isMyList, mediaID: movieID)
                }
            }
        }
    }
}
