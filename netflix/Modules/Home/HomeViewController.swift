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
    private var allGenreButton = ArrowDownButton(title: "All genres")
    private var isFirstLaunch = true
    
    private var tvShowButtonLeading: NSLayoutConstraint!
    private var moviesButtonLeading: NSLayoutConstraint!
    private var myListButtonLeading: NSLayoutConstraint!
    private var allGenreButtonLeading: NSLayoutConstraint!
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
                if self.isShowingGenres == false {
                    self.animateTVShowSelected()
                } else {
                    self.animateTVShowDeselected()
                }
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
        
        tvShowButtonLeading = tvShowButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: -UIScreen.main.bounds.width)
        
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
        
        moviesButtonLeading = moviesButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -UIScreen.main.bounds.width)
        moviesButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(moviesButton)
        moviesButtonLeading.isActive = true
        moviesButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        moviesButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        moviesButtonWidth = moviesButton.widthAnchor.constraint(equalToConstant: 0)
        moviesButtonWidth.isActive = true
        
        myListButtonLeading = myListButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: -UIScreen.main.bounds.width)
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(myListButton)
        myListButtonLeading.isActive = true
        myListButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        myListButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        myListButtonWidth = myListButton.widthAnchor.constraint(equalToConstant: 0)
        myListButtonWidth.isActive = true
        
        allGenreButtonLeading = allGenreButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -UIScreen.main.bounds.width)
        allGenreButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(allGenreButton)
        allGenreButtonLeading.isActive = true
        allGenreButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        allGenreButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
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
            self.tvShowButton.alpha = 1
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateTVShowSelected() {
        tvShowButton.deactiveWidthConstraints()
        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allGenreButtonLeading.constant = topButtonSpacing * 2
        self.tvShowButton.showDropdown = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.setTitle(title: "thanh20cmtsfhfhs")
            self.tvShowButton.transform = transform
        }) { _ in
            self.isShowingGenres = true
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.moviesButton.alpha = 0
            self.myListButton.alpha = 0
            self.allGenreButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { _ in
            self.moviesButtonLeading.constant = -UIScreen.main.bounds.width
            self.myListButtonLeading.constant = -UIScreen.main.bounds.width
        }
    }
    
    private func animateTVShowDeselected() {
        
    }
}
