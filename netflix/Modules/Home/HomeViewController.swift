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

class HomeViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: HomeViewModel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoButton: UIButton!
    
    private var tvShowButton = ArrowDownButton(title: CategoryType.tvShow.rawValue)
    private var moviesButton = ArrowDownButton(title: CategoryType.movies.rawValue)
    private var myListButton = ArrowDownButton(title: CategoryType.mylist.rawValue)
    private var allGenreButton = ArrowDownButton(title: "All genres")
    private var isFirstLaunch = true
    
    private var tvShowButtonLeading: NSLayoutConstraint!
    private var moviesButtonLeading: NSLayoutConstraint!
    private var myListButtonLeading: NSLayoutConstraint!
    private var allGenreLeadingTvShow: NSLayoutConstraint!
    private var allGenreLeadingMovie: NSLayoutConstraint!
    private var tvShowButtonWidth: NSLayoutConstraint!
    private var moviesButtonWidth: NSLayoutConstraint!
    private var myListButtonWidth: NSLayoutConstraint!
    
    private let topButtonSpacing: CGFloat = 10
    private var defaultButtonWidth: CGFloat!
    
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        bind()
        handleAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            defaultButtonWidth = (categoryView.frame.size.width - topButtonSpacing * 4)/3
            isFirstLaunch = false
        }
        view.bringSubviewToFront(iconImageView)
    }
    
    override func prepareUI() {
        configNavigationBar()
    }
    
    private func bind() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in 1 }.asDriverOnErrorJustComplete()
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).filter({ [weak self] _ -> Bool in
            return (self?.isFirstLaunch ?? false)
        }).mapToVoid().asDriverOnErrorJustComplete()
        
        let input = HomeViewModel.Input(fetchTrigger: viewWillAppear, getGenresTrigger: viewDidAppear)
        let output = viewModel.transform(input: input)
        
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.fetchResult
            .drive(onNext: { movies in
                print(movies.map { $0.originalTitle })
            })
            .disposed(by: bag)
        
//        output.indicator.drive(ProgressHelper.rx.isAnimating).disposed(by: bag)
        
        output.TVGenres
            .drive(onNext: { genres in
                TVGenreRealmObject.deleteAllGenres()
                TVGenreRealmObject.save(genres: genres)
            })
            .disposed(by: bag)
        
        output.movieGenres
            .drive(onNext: { genres in
                MovieGenreRealmObject.deleteAllGenres()
                MovieGenreRealmObject.save(genres: genres)
            })
            .disposed(by: bag)
        
        Observable.zip(output.TVGenres.asObservable(), output.movieGenres.asObservable())
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.initialGenreButtons()
                self.addGenreButtons()
            })
            .disposed(by: bag)
    }
    
    private func handleAction() {
        tvShowButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch PersistentManager.shared.categoryType {
                case .home:
                    PersistentManager.shared.categoryType = .tvShow
                    self.animateTVShowSelected()
                    //load tv show data
                case .tvShow:
                    self.showChooseCategoryTypeView()
                default:
                    break
                }
            })
            .disposed(by: bag)
        
        moviesButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch PersistentManager.shared.categoryType {
                case .home:
                    PersistentManager.shared.categoryType = .movies
                    self.animateMoviesSelected()
                    //load tv show data
                case .movies:
                    self.showChooseCategoryTypeView()
                default:
                    break
                }
            })
            .disposed(by: bag)
        
        myListButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch PersistentManager.shared.categoryType {
                case .home:
                    PersistentManager.shared.categoryType = .mylist
                    self.animateMyListSelected()
                    //load tv show data
                case .mylist:
                    self.showChooseCategoryTypeView()
                default:
                    break
                }
            })
            .disposed(by: bag)
        
        logoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                PersistentManager.shared.categoryType = .home
                self.animateGenresDeselected()
            })
            .disposed(by: bag)
        
        allGenreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showChooseCategoryView()
            })
            .disposed(by: bag)
    }
}

extension HomeViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func initialGenreButtons() {
        tvShowButton.alpha = 0
        moviesButton.alpha = 0
        myListButton.alpha = 0
        allGenreButton.alpha = 0
        allGenreButton.isHidden = true
        tvShowButton.isHidden = true
        moviesButton.isHidden = true
        myListButton.isHidden = true
        
        allGenreButton.transformIcon = true
        allGenreButton.fontSize = 11
        
        tvShowButtonLeading = tvShowButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: -50)
        
        tvShowButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(tvShowButton)
        tvShowButtonLeading.isActive = true
        tvShowButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        tvShowButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        tvShowButtonWidth = tvShowButton.widthAnchor.constraint(equalToConstant: 0)
        tvShowButtonWidth.isActive = true
        
        moviesButtonLeading = moviesButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: topButtonSpacing + defaultButtonWidth - 50)
        moviesButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(moviesButton)
        moviesButtonLeading.isActive = true
        moviesButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        moviesButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        moviesButtonWidth = moviesButton.widthAnchor.constraint(equalToConstant: 0)
        moviesButtonWidth.isActive = true
        
        myListButtonLeading = myListButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: (defaultButtonWidth + topButtonSpacing) * 2 - 50)
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(myListButton)
        myListButtonLeading.isActive = true
        myListButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        myListButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        myListButtonWidth = myListButton.widthAnchor.constraint(equalToConstant: 0)
        myListButtonWidth.isActive = true
        
        allGenreLeadingTvShow = allGenreButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -50)
        allGenreLeadingMovie = allGenreButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: -50)
        allGenreButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(allGenreButton)
        allGenreLeadingTvShow.isActive = true
        allGenreButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        allGenreButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
    }
    
    private func addGenreButtons() {
        tvShowButtonWidth.constant = defaultButtonWidth
        moviesButtonWidth.constant = defaultButtonWidth
        myListButtonWidth.constant = defaultButtonWidth
        
        tvShowButtonLeading.constant = topButtonSpacing
        moviesButtonLeading.constant = defaultButtonWidth + topButtonSpacing * 2
        myListButtonLeading.constant = defaultButtonWidth * 2 + topButtonSpacing * 3
        
        UIView.animate(withDuration: 0.5) {
            self.tvShowButton.isHidden = false
            self.moviesButton.isHidden = false
            self.myListButton.isHidden = false
            self.tvShowButton.alpha = 1
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController {
    private func animateTVShowSelected() {
        tvShowButton.deactiveWidthConstraints()
        allGenreLeadingMovie.isActive = false
        allGenreLeadingTvShow.isActive = true
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allGenreLeadingTvShow.constant = topButtonSpacing * 2
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.isHidden = false
            self.tvShowButton.alpha = 1
            self.tvShowButton.transformIcon = true
            self.tvShowButton.scale = true
        }) { _ in
            self.allGenreLeadingMovie.constant = -50
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.moviesButton.alpha = 0
            self.myListButton.alpha = 0
            self.allGenreButton.alpha = 1
            self.allGenreButton.isHidden = false
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.moviesButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    private func animateGenresDeselected() {
        tvShowButtonWidth.constant = defaultButtonWidth
        moviesButtonWidth.constant = defaultButtonWidth
        myListButtonWidth.constant = defaultButtonWidth
        tvShowButtonWidth.isActive = true
        moviesButtonWidth.isActive = true
        myListButtonWidth.isActive = true
        allGenreLeadingTvShow.isActive = true
        allGenreLeadingMovie.isActive = false
        tvShowButtonLeading.constant = topButtonSpacing
        moviesButtonLeading.constant = defaultButtonWidth + topButtonSpacing * 2
        myListButtonLeading.constant = defaultButtonWidth * 2 + topButtonSpacing * 3
        allGenreLeadingTvShow.constant = -50
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.transformIcon = false
            self.tvShowButton.scale = false
            self.moviesButton.transformIcon = false
            self.moviesButton.scale = false
            self.myListButton.transformIcon = false
            self.myListButton.scale = false
        }) { _ in
            self.allGenreLeadingMovie.constant = -50
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.tvShowButton.alpha = 1
            self.tvShowButton.isHidden = false
            self.moviesButton.isHidden = false
            self.myListButton.isHidden = false
            self.allGenreButton.alpha = 0
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.allGenreButton.isHidden = true
        }
    }
    
    private func animateMoviesSelected() {
        allGenreLeadingTvShow.isActive = false
        allGenreLeadingMovie.isActive = true
        moviesButton.deactiveWidthConstraints()
        moviesButtonLeading.constant = topButtonSpacing
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allGenreLeadingMovie.constant = topButtonSpacing * 2
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.moviesButton.isHidden = false
            self.moviesButton.alpha = 1
            self.moviesButton.transformIcon = true
            self.moviesButton.scale = true
        }) { _ in
            self.allGenreLeadingTvShow.constant = -50
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tvShowButton.alpha = 0
            self.myListButton.alpha = 0
            self.allGenreButton.alpha = 1
            self.allGenreButton.isHidden = false
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.tvShowButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    private func animateMyListSelected() {
        myListButton.deactiveWidthConstraints()
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = topButtonSpacing
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.myListButton.isHidden = false
            self.myListButton.alpha = 1
            self.myListButton.transformIcon = true
            self.myListButton.scale = true
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tvShowButton.alpha = 0
            self.moviesButton.alpha = 0
            self.allGenreButton.alpha = 0
            self.allGenreButton.isHidden = true
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.tvShowButton.isHidden = true
            self.moviesButton.isHidden = true
        }
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
                }
            })
            .disposed(by: bag)
    }
}

extension HomeViewController {
    private func handleCategoryTypeChange(type: CategoryType) {
        guard type != PersistentManager.shared.categoryType else {
            //load currentType data
            return
        }
        PersistentManager.shared.categoryType = type
        //load currentType data
        switch type {
        case .home:
            animateGenresDeselected()
        case .tvShow:
            animateTVShowSelected()
        case .movies:
            animateMoviesSelected()
        case .mylist:
            animateMyListSelected()
        }
    }
    
    private func handleCategoryChange(genre: Genre) {
        
    }
}
