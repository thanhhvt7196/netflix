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
    private var isFirstLaunch = true
    
    private let bag = DisposeBag()
    
    private var homeCategoryView: HomeCategoryView!
    private var tvShowCategoryView: TVShowCategoryView!
    private var movieCategoryView: MovieCategoryView!
    private var mylistCategoryView: MyListCategoryView!
    
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
        homeCategoryView = HomeCategoryView(viewModel: homeCategoryViewModel, frame: containerView.bounds)
        
        let tvShowCategoryViewModel = TVShowCategoryViewModel()
        tvShowCategoryView = TVShowCategoryView(viewModel: tvShowCategoryViewModel, frame: containerView.bounds)
        
        let movieCategoryViewModel = MoviesCategoryViewModel()
        movieCategoryView = MovieCategoryView(viewModel: movieCategoryViewModel, frame: containerView.bounds)
        
        let mylistCategoryViewModel = MyListCategoryViewModel()
        mylistCategoryView = MyListCategoryView(viewModel: mylistCategoryViewModel, frame: containerView.bounds)
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
                        self.tvShowCategoryView.loadData(genreID: PersistentManager.shared.currentGenre)
                    case .movies:
                        self.movieCategoryView.loadData(genreID: PersistentManager.shared.currentGenre)
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
            containerView.addSubViewWithAnimation(view: homeCategoryView)
            homeCategoryView.loadData()
        case .tvShow:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: tvShowCategoryView)
            tvShowCategoryView.loadData(genreID: PersistentManager.shared.currentGenre)
        case .movies:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: movieCategoryView)
            movieCategoryView.loadData(genreID: PersistentManager.shared.currentGenre)
        case .mylist:
            containerView.subviews.forEach({ $0.removeFromSuperview()})
            containerView.addSubViewWithAnimation(view: mylistCategoryView)
            mylistCategoryView.loadData()
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
