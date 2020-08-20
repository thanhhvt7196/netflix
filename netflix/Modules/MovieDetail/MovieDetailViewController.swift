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
    
    private let pagerHeaderView = PagerHeaderSectionView()
    
    var viewModel: MovieDetailViewModel!
    private let bag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<MovieDetailSectionModel>!
    
    private let defaultBlueViewHeight: CGFloat = 300
    
    private let getMovieDetailTrigger = PublishSubject<Void>()
    private let selectedContentIndex = BehaviorRelay<Int>(value: 0)
    
    override func loadView() {
        super.loadView()
        blurViewHeightConstraint.constant = defaultBlueViewHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
        getMovieDetail()
    }
    
    override func prepareUI() {
        super.prepareUI()
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
        
    }
}

extension MovieDetailViewController {
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
    }
}

extension MovieDetailViewController: PagerHeaderSectionViewDelegate {
    func itemSelected(at index: Int) {
        selectedContentIndex.accept(index)
    }
}
