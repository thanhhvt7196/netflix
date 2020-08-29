//
//  HomeViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa
import UIKit

class HomeViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    var viewModel: HomeViewModel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var categoryView: CategoryAnimationView!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradientContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientViewTopConstraint: NSLayoutConstraint!
    
    private var isFirstLaunch = true
    private let bag = DisposeBag()
    
    private var homeCategoryViewController: HomeCategoryViewController!
    private var tvShowCategoryViewController: TVShowCategoryViewController!
    private var moviesCategoryViewController: MoviesCategoryViewController!
    private var mylistViewController: MyListViewController!
    
    private var gradientViewHeight: CGFloat!
    
    private var scrollableView: UIScrollView? {
        didSet {
            stopFollowScrollView()
            followScrollView()
        }
    }
    private var panGestureRecognizer: UIPanGestureRecognizer?

    private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    private var previousState = CategoryViewState.expanded
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        gradientContainerTopConstraint.constant = UIApplication.shared.currentWindow?.safeAreaInsets.top ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        categoryView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            gradientViewHeight = gradientView.frame.height
            isFirstLaunch = false
        }
        view.bringSubviewToFront(iconImageView)
    }
    
    private func bind() {
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .filter({ [weak self] _ -> Bool in
                return (self?.isFirstLaunch ?? false)
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = HomeViewModel.Input(getGeneralDataTrigger: viewDidAppear)
        let output = viewModel.transform(input: input)
        
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.homeGeneralData
            .map { $0.tvGenres ?? [] }
            .drive(onNext: { genres in
                TVGenreRealmObject.deleteAllGenres()
                TVGenreRealmObject.save(genres: genres)
            })
            .disposed(by: bag)
        
        output.homeGeneralData
            .map { $0.movieGenres ?? [] }
            .drive(onNext: { genres in
                MovieGenreRealmObject.deleteAllGenres()
                MovieGenreRealmObject.save(genres: genres)
            })
            .disposed(by: bag)
        
        output.homeGeneralData
            .map { [$0.tvShowWatchList ?? [], $0.movieWatchList ?? []] }
            .map { ArrayHelper.combine(arrays: $0) }
            .drive(onNext: { watchList in
                PersistentManager.shared.watchList = watchList
            })
            .disposed(by: bag)
        
        output.homeGeneralData
            .map { [$0.tvShowFavoriteList ?? [], $0.movieFavoriteList ?? []] }
            .map { ArrayHelper.combine(arrays: $0) }
            .drive(onNext: { favoriteList in
                PersistentManager.shared.favoriteList = favoriteList
            })
            .disposed(by: bag)
        
        output.homeGeneralData
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let spacing: CGFloat = 10
                let buttonWidth = (self.categoryView.frame.size.width - spacing * 4)/3
                self.categoryView.initialGenreButtons(buttonWidth: buttonWidth, spacing: spacing)
                self.categoryView.addGenreButtons()
                self.initialChildViews()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.changeCategoryView(type: .home)
                }
            })
            .disposed(by: bag)
    }
    
    private func handleAction() {
        logoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                PersistentManager.shared.categoryType = .home
                self.categoryView.animateGenresDeselected()
                self.changeCategoryView(type: .home)
            })
            .disposed(by: bag)
    }
}

extension HomeViewController {
    private func initialChildViews() {
        let homeCategoryViewModel = HomeCategoryViewModel()
        homeCategoryViewController = HomeCategoryViewController.instantiate(withViewModel: homeCategoryViewModel)
        addChild(homeCategoryViewController)
        homeCategoryViewController.view.frame = containerView.bounds
        homeCategoryViewController.didMove(toParent: self)
        homeCategoryViewController.scrollDelegate = self
        
        let tvShowCategoryViewModel = TVShowCategoryViewModel()
        tvShowCategoryViewController = TVShowCategoryViewController.instantiate(withViewModel: tvShowCategoryViewModel)
        addChild(tvShowCategoryViewController)
        tvShowCategoryViewController.view.frame = containerView.bounds
        tvShowCategoryViewController.didMove(toParent: self)
        tvShowCategoryViewController.scrollDelegate = self
        
        let movieCategoryViewModel = MoviesCategoryViewModel()
        moviesCategoryViewController = MoviesCategoryViewController.instantiate(withViewModel: movieCategoryViewModel)
        addChild(moviesCategoryViewController)
        moviesCategoryViewController.view.frame = containerView.bounds
        moviesCategoryViewController.didMove(toParent: self)
        moviesCategoryViewController.scrollDelegate = self
        
        let mylistViewModel = MyListViewModel(isTabbarItem: false)
        mylistViewController = MyListViewController.instantiate(withViewModel: mylistViewModel)
        addChild(mylistViewController)
        mylistViewController.view.frame = containerView.bounds
        mylistViewController.collectionView.contentInset = UIEdgeInsets(top: categoryView.frame.height, left: 0, bottom: 0, right: 0)
        mylistViewController.didMove(toParent: self)
        mylistViewController.scrollDelegate = self
    }
}

extension HomeViewController {
    private func showChooseCategoryTypeView() {
        let chooseCategoryTypeViewModel = ChooseCategoryTypeViewModel()
        let chooseCategoryTypeView = ChooseCategoryTypeView(viewModel: chooseCategoryTypeViewModel, frame: UIScreen.main.bounds)
        UIApplication.addSubviewToWindow(view: chooseCategoryTypeView)
        chooseCategoryTypeView
            .selectedCategoryType
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                chooseCategoryTypeView.dismissWithAnimation {
                    self.handleCategoryTypeChange(type: type)
                    self.changeCategoryView(type: type)
                }
            })
            .disposed(by: bag)
    }
    
    private func showChooseCategoryView() {
        let chooseCategoryViewModel = ChooseCategoryViewModel()
        let chooseCategoryView = ChooseCategoryView(viewModel: chooseCategoryViewModel, frame: UIScreen.main.bounds)
        UIApplication.addSubviewToWindow(view: chooseCategoryView)
        chooseCategoryView.selectedGenre
            .subscribe(onNext: { [weak self] genre in
                guard let self = self else { return }
                chooseCategoryView.dismissWithAnimation {
                    self.handleCategoryChange(genre: genre)
                    switch PersistentManager.shared.categoryType {
                    case .home, .mylist:
                        break
                    case .tvShow:
                        self.tvShowCategoryViewController.loadData(genreID: PersistentManager.shared.currentGenre)
                    case .movies:
                        self.moviesCategoryViewController.loadData(genreID: PersistentManager.shared.currentGenre)
                    }
                }
            })
            .disposed(by: chooseCategoryView.bag)
    }
}

extension HomeViewController {
    private func handleCategoryTypeChange(type: CategoryType) {
        guard type != PersistentManager.shared.categoryType else {
            PersistentManager.shared.currentGenre = PersistentManager.shared.allGenre.id
            categoryView.setAllGenreButtonTitle(title: Strings.allGenres)
            return
        }
        PersistentManager.shared.categoryType = type
        PersistentManager.shared.currentGenre = PersistentManager.shared.allGenre.id
        categoryView.setAllGenreButtonTitle(title: Strings.allGenres)
        switch type {
        case .home:
            categoryView.animateGenresDeselected()
        case .tvShow:
            categoryView.animateTVShowSelected()
        case .movies:
            categoryView.animateMoviesSelected()
        case .mylist:
            categoryView.animateMyListSelected()
        }
    }
    
    private func handleCategoryChange(genre: Genre) {
        PersistentManager.shared.currentGenre = genre.id
        categoryView.setAllGenreButtonTitle(title: genre.name ?? Strings.allGenres)
    }
}

extension HomeViewController {
    private func changeCategoryView(type: CategoryType) {
        switch type {
        case .home:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: homeCategoryViewController.view)
            homeCategoryViewController.loadData()
            scrollableView = homeCategoryViewController.tableView
        case .tvShow:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: tvShowCategoryViewController.view)
            tvShowCategoryViewController.loadData(genreID: PersistentManager.shared.currentGenre)
            scrollableView = tvShowCategoryViewController.tableView
        case .movies:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: moviesCategoryViewController.view)
            moviesCategoryViewController.loadData(genreID: PersistentManager.shared.currentGenre)
            scrollableView = moviesCategoryViewController.tableView
        case .mylist:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: mylistViewController.view)
            mylistViewController.loadData()
            scrollableView = mylistViewController.collectionView
        }
    }
}

extension HomeViewController: CategoryAnimationViewDelegate {
    func mylistTapped() {
        switch PersistentManager.shared.categoryType {
        case .home:
            PersistentManager.shared.categoryType = .mylist
            self.categoryView.animateMyListSelected()
            self.changeCategoryView(type: .mylist)
        case .mylist:
            self.showChooseCategoryTypeView()
        default:
            break
        }
    }
    
    func tvShowTapped() {
        switch PersistentManager.shared.categoryType {
        case .home:
            PersistentManager.shared.categoryType = .tvShow
            self.categoryView.animateTVShowSelected()
            self.changeCategoryView(type: .tvShow)
        case .tvShow:
            self.showChooseCategoryTypeView()
        default:
            break
        }
    }
    
    func moviesTapped() {
        switch PersistentManager.shared.categoryType {
        case .home:
            PersistentManager.shared.categoryType = .movies
            self.categoryView.animateMoviesSelected()
            self.changeCategoryView(type: .movies)
        case .movies:
            self.showChooseCategoryTypeView()
        default:
            break
        }
    }
    
    func genreTapped() {
        self.showChooseCategoryView()
    }
}

extension HomeViewController {
    private func stopFollowScrollView() {
        if let gesture = panGestureRecognizer {
            scrollableView?.removeGestureRecognizer(gesture)
        }
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func followScrollView() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer?.maximumNumberOfTouches = 1
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.cancelsTouchesInView = false
        if let gesture = panGestureRecognizer {
            scrollableView?.addGestureRecognizer(gesture)
        }
        gradientView.backgroundColor = UIColor.black.withAlphaComponent(0)
        previousOrientation = UIDevice.current.orientation
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate(_:)), name: UIDevice.orientationDidChangeNotification, object:  nil)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .changed:
            if gradientViewTopConstraint.constant <= 0 && gradientViewTopConstraint.constant >= -gradientViewHeight {
                let constant = gradientViewTopConstraint.constant
                if constant + translation.y > 0 {
                    gradientViewTopConstraint.constant = 0
                } else if constant + translation.y < -gradientViewHeight {
                    gradientViewTopConstraint.constant = -gradientViewHeight
                } else {
                    gradientViewTopConstraint.constant = constant + translation.y
                }
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            abs(gradientViewTopConstraint.constant/gradientViewHeight) < 0.5 ? showCategoryView() : hideCategoryView()
        default:
            break
        }
    }
}

extension HomeViewController {
    private func showCategoryView() {
        gradientViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.gradientView.backgroundColor = UIColor.black.withAlphaComponent(self.percentage)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideCategoryView() {
        gradientViewTopConstraint.constant = -self.gradientViewHeight
        UIView.animate(withDuration: 0.2) {
            self.gradientView.backgroundColor = UIColor.black.withAlphaComponent(self.percentage)
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController {
    private enum CategoryViewState: Int {
        case collapsed
        case expanded
        case scrolling
        
        var description: String {
            switch self {
            case .collapsed:
                return "collapsed"
            case .expanded:
                return "expanded"
            case .scrolling:
                return "scrolling"
            }
        }
    }
    
    private var state: CategoryViewState {
        if gradientViewTopConstraint.constant <= -gradientView.frame.height {
            return .collapsed
        } else if gradientViewTopConstraint.constant == 0 {
            return .expanded
        } else {
            return .scrolling
        }
    }
    
    private var percentage: CGFloat {
        switch PersistentManager.shared.categoryType {
        case .mylist:
            return 1
        default:
            guard let tableView = scrollableView as? UITableView,
                let cell = tableView.visibleCells.compactMap({ $0 as? HeaderMovieTableViewCell }).first
            else {
                return 1
            }
            return min(1, max(tableView.contentOffset.y, 0) / (cell.bounds.height/2)) 
        }
    }
}

extension HomeViewController {
    @objc private func willResignActive(_ notification: Notification) {
        previousState = state
    }
    
    @objc private func didRotate(_ notification: Notification) {
        
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let currentTableView = scrollableView else { return false }
        return touch.view?.isDescendant(of: currentTableView) ?? false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let recognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = recognizer.velocity(in: gestureRecognizer.view)
        return abs(velocity.y) > abs(velocity.x)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension HomeViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        gradientView.backgroundColor = UIColor.black.withAlphaComponent(percentage)
    }
}
