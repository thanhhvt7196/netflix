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
    private var allGenreButton = ArrowDownButton()
    private var isFirstLaunch = true
    
    private var isShowingGenres = false
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            addGenreButtons()
            isFirstLaunch = false
        }
        view.bringSubviewToFront(iconImageView)
    }
    
    override func prepareUI() {
        configNavigationBar()
    }
    
    private func bind() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in 3 }.asDriverOnErrorJustComplete()
        let input = HomeViewModel.Input(fetchTrigger: viewWillAppear)
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
        
        output.indicator.drive(ProgressHelper.rx.isAnimating).disposed(by: bag)
    }
}

extension HomeViewController {
    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func addGenreButtons() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        
        let spacing: CGFloat = 10
        let defaultWidth = (categoryView.frame.size.width - spacing * 4)/3
        let tvShowButtonLeading = tvShowButton.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: spacing)
        tvShowButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(tvShowButton)
        tvShowButtonLeading.isActive = true
        tvShowButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        tvShowButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        tvShowButton.widthAnchor.constraint(equalToConstant: defaultWidth).isActive = true
        
        let moviesButtonLeading = moviesButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: spacing)
        moviesButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(moviesButton)
        moviesButtonLeading.isActive = true
        moviesButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        moviesButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        moviesButton.widthAnchor.constraint(equalToConstant: defaultWidth).isActive = true
        
        let myListButtonLeading = myListButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: spacing)
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(myListButton)
        myListButtonLeading.isActive = true
        myListButton.heightAnchor.constraint(equalTo: logoButton.heightAnchor).isActive = true
        myListButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
        myListButton.widthAnchor.constraint(equalToConstant: defaultWidth).isActive = true
    }
}
