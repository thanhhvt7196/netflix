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
    
    private var tvShowButton = ArrowDownButton(title: "TV Shows")
    private var moviesButton = ArrowDownButton(title: "Movies")
    private var myListButton = ArrowDownButton(title: "My list")
    private var allTVGenreButton = ArrowDownButton(title: "All genres")
    private var allMovieGenreButton = ArrowDownButton(title: "Movie genres")
    private var isFirstLaunch = true
    
    private var tvShowButtonLeading: NSLayoutConstraint!
    private var moviesButtonLeading: NSLayoutConstraint!
    private var myListButtonLeading: NSLayoutConstraint!
    private var allTVGenreButtonLeading: NSLayoutConstraint!
    private var allMovieGenreButtonLeading: NSLayoutConstraint!
    private var tvShowButtonWidth: NSLayoutConstraint!
    private var moviesButtonWidth: NSLayoutConstraint!
    private var myListButtonWidth: NSLayoutConstraint!
    
    private var isShowingGenres = false
    private let topButtonSpacing: CGFloat = 10
    
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
            isFirstLaunch = false
        }
        view.bringSubviewToFront(iconImageView)
    }
    
    override func prepareUI() {
        configNavigationBar()
        initialGenreButtons()
    }
    
    private func bind() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in 3 }.asDriverOnErrorJustComplete()
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
        
        output.genres
            .drive(onNext: { [weak self] genres in
                guard let self = self else { return }
                print(genres)
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
        allTVGenreButton.alpha = 0
        allMovieGenreButton.alpha = 0
        allMovieGenreButton.isHidden = true
        allTVGenreButton.isHidden = true
        tvShowButton.isHidden = true
        moviesButton.isHidden = true
        myListButton.isHidden = true
        
        allTVGenreButton.transformIcon = true
        allTVGenreButton.fontSize = 11
        allMovieGenreButton.transformIcon = true
        allMovieGenreButton.fontSize = 11
        
        tvShowButtonLeading = tvShowButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: -50)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        transition.subtype = .fromLeft
        categoryView.layer.add(transition, forKey: nil)
        
        tvShowButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(tvShowButton)
        tvShowButtonLeading.isActive = true
        tvShowButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        tvShowButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        tvShowButtonWidth = tvShowButton.widthAnchor.constraint(equalToConstant: 0)
        tvShowButtonWidth.isActive = true
        
        moviesButtonLeading = moviesButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -50)
        moviesButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(moviesButton)
        moviesButtonLeading.isActive = true
        moviesButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        moviesButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        moviesButtonWidth = moviesButton.widthAnchor.constraint(equalToConstant: 0)
        moviesButtonWidth.isActive = true
        
        myListButtonLeading = myListButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: -50)
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(myListButton)
        myListButtonLeading.isActive = true
        myListButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        myListButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        myListButtonWidth = myListButton.widthAnchor.constraint(equalToConstant: 0)
        myListButtonWidth.isActive = true
        
        allTVGenreButtonLeading = allTVGenreButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -50)
        allTVGenreButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(allTVGenreButton)
        allTVGenreButtonLeading.isActive = true
        allTVGenreButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        allTVGenreButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        
        allMovieGenreButtonLeading = allMovieGenreButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: -50)
        allMovieGenreButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(allMovieGenreButton)
        allMovieGenreButtonLeading.isActive = true
        allMovieGenreButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        allMovieGenreButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
    }
    
    private func addGenreButtons() {
        let defaultWidth = (categoryView.frame.size.width - topButtonSpacing * 4)/3
        tvShowButtonWidth.constant = defaultWidth
        moviesButtonWidth.constant = defaultWidth
        myListButtonWidth.constant = defaultWidth
        
        tvShowButtonLeading.constant = topButtonSpacing
        moviesButtonLeading.constant = topButtonSpacing
        myListButtonLeading.constant = topButtonSpacing
        
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
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allTVGenreButtonLeading.constant = topButtonSpacing * 2
        allMovieGenreButtonLeading.constant = -50
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.isHidden = false
            self.tvShowButton.alpha = 1
            self.tvShowButton.transformIcon = true
            self.tvShowButton.scale = true
        }) { _ in
            self.isShowingGenres = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.moviesButton.alpha = 0
            self.myListButton.alpha = 0
            self.allTVGenreButton.alpha = 1
            self.allTVGenreButton.isHidden = false
            self.allMovieGenreButton.alpha = 0
            self.allMovieGenreButton.isHidden = true
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.moviesButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    private func animateGenresDeselected() {
        let defaultWidth = (categoryView.frame.size.width - topButtonSpacing * 4)/3
        tvShowButtonWidth.constant = defaultWidth
        moviesButtonWidth.constant = defaultWidth
        myListButtonWidth.constant = defaultWidth
        tvShowButtonWidth.isActive = true
        moviesButtonWidth.isActive = true
        myListButtonWidth.isActive = true
        moviesButtonLeading.constant = topButtonSpacing
        myListButtonLeading.constant = topButtonSpacing
        tvShowButtonLeading.constant = topButtonSpacing
        allTVGenreButtonLeading.constant = -50
        allMovieGenreButtonLeading.constant = -50
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.transformIcon = false
            self.tvShowButton.scale = false
            self.moviesButton.transformIcon = false
            self.moviesButton.scale = false
            self.myListButton.transformIcon = false
            self.myListButton.scale = false
        }) { _ in
            self.isShowingGenres = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.tvShowButton.alpha = 1
            self.tvShowButton.isHidden = false
            self.moviesButton.isHidden = false
            self.myListButton.isHidden = false
            self.allTVGenreButton.alpha = 0
            self.allMovieGenreButton.alpha = 0
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.allMovieGenreButton.isHidden = true
            self.allTVGenreButton.isHidden = true
        }
    }
    
    private func animateMoviesSelected() {
        moviesButton.deactiveWidthConstraints()
        let tvShowWidth = tvShowButton.frame.width
        tvShowButtonLeading.constant = tvShowButtonLeading.constant - tvShowWidth - topButtonSpacing
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allMovieGenreButtonLeading.constant = topButtonSpacing * 2
        allTVGenreButtonLeading.constant = -50
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.moviesButton.isHidden = false
            self.moviesButton.alpha = 1
            self.moviesButton.transformIcon = true
            self.moviesButton.scale = true
        }) { _ in
            self.isShowingGenres = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tvShowButton.alpha = 0
            self.myListButton.alpha = 0
            self.allMovieGenreButton.alpha = 1
            self.allMovieGenreButton.isHidden = false
            self.allTVGenreButton.alpha = 0
            self.allTVGenreButton.isHidden = true
            self.categoryView.layoutIfNeeded()
        }) { _ in
            self.tvShowButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    private func animateMyListSelected() {
        myListButton.deactiveWidthConstraints()
        tvShowButtonWidth.constant = 0
        moviesButtonWidth.constant = 0
        myListButtonLeading.constant = -topButtonSpacing
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.myListButton.isHidden = false
            self.myListButton.alpha = 1
            self.myListButton.transformIcon = true
            self.myListButton.scale = true
        }) { _ in
            self.isShowingGenres = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tvShowButton.alpha = 0
            self.moviesButton.alpha = 0
            self.allMovieGenreButton.alpha = 0
            self.allMovieGenreButton.isHidden = true
            self.allTVGenreButton.alpha = 0
            self.allTVGenreButton.isHidden = true
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
}
