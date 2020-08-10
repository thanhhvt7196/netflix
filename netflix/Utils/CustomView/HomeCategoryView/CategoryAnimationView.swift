//
//  HomeCategoryView.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryAnimationViewDelegate: class {
    func mylistTapped()
    func tvShowTapped()
    func moviesTapped()
    func genreTapped()
}

class CategoryAnimationView: UIView {
    private var tvShowButton = ArrowDownButton(title: CategoryType.tvShow.rawValue)
    private var moviesButton = ArrowDownButton(title: CategoryType.movies.rawValue)
    private var myListButton = ArrowDownButton(title: CategoryType.mylist.rawValue)
    private var allGenreButton = ArrowDownButton(title: PersistentManager.shared.allGenre.name ?? "")

    private var tvShowButtonLeading: NSLayoutConstraint!
    private var moviesButtonLeading: NSLayoutConstraint!
    private var myListButtonLeading: NSLayoutConstraint!
    private var allGenreLeadingTvShow: NSLayoutConstraint!
    private var allGenreLeadingMovie: NSLayoutConstraint!
    private var tvShowButtonWidth: NSLayoutConstraint!
    private var moviesButtonWidth: NSLayoutConstraint!
    private var myListButtonWidth: NSLayoutConstraint!
    
    private let showCategoryTypeAnimationDuration = 0.5
    private let categoryTypeButtonAnimationDuration = 0.3
    
    private var topButtonSpacing: CGFloat!
    private var defaultButtonWidth: CGFloat!
    
    weak var delegate: CategoryAnimationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        handleAction()
    }
    
    private func handleAction() {
        tvShowButton.addTarget(target: self, selector: #selector(tvShowTapped))
        moviesButton.addTarget(target: self, selector: #selector(moviesTapped))
        myListButton.addTarget(target: self, selector: #selector(mylistTapped))
        allGenreButton.addTarget(target: self, selector: #selector(genreTapped))
    }
}

extension CategoryAnimationView {
    func initialGenreButtons(buttonWidth: CGFloat, spacing: CGFloat) {
        defaultButtonWidth = buttonWidth
        topButtonSpacing = spacing
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
        
        tvShowButtonLeading = tvShowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -50)
        
        tvShowButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tvShowButton)
        tvShowButtonLeading.isActive = true
        tvShowButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        tvShowButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tvShowButtonWidth = tvShowButton.widthAnchor.constraint(equalToConstant: 0)
        tvShowButtonWidth.isActive = true
        
        moviesButtonLeading = moviesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: topButtonSpacing + defaultButtonWidth - 50)
        moviesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moviesButton)
        moviesButtonLeading.isActive = true
        moviesButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        moviesButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moviesButtonWidth = moviesButton.widthAnchor.constraint(equalToConstant: 0)
        moviesButtonWidth.isActive = true
        
        myListButtonLeading = myListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (defaultButtonWidth + topButtonSpacing) * 2 - 50)
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(myListButton)
        myListButtonLeading.isActive = true
        myListButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        myListButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myListButtonWidth = myListButton.widthAnchor.constraint(equalToConstant: 0)
        myListButtonWidth.isActive = true
        
        allGenreLeadingTvShow = allGenreButton.leadingAnchor.constraint(equalTo: tvShowButton.trailingAnchor, constant: -50)
        allGenreLeadingMovie = allGenreButton.leadingAnchor.constraint(equalTo: moviesButton.trailingAnchor, constant: -50)
        allGenreButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(allGenreButton)
        allGenreLeadingTvShow.isActive = true
        allGenreButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        allGenreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func addGenreButtons() {
        tvShowButtonWidth.constant = defaultButtonWidth
        moviesButtonWidth.constant = defaultButtonWidth
        myListButtonWidth.constant = defaultButtonWidth
        
        tvShowButtonLeading.constant = topButtonSpacing
        moviesButtonLeading.constant = defaultButtonWidth + topButtonSpacing * 2
        myListButtonLeading.constant = defaultButtonWidth * 2 + topButtonSpacing * 3
        
        UIView.animate(withDuration: showCategoryTypeAnimationDuration) {
            self.tvShowButton.isHidden = false
            self.moviesButton.isHidden = false
            self.myListButton.isHidden = false
            self.tvShowButton.alpha = 1
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func animateTVShowSelected() {
        tvShowButton.deactiveWidthConstraints()
        allGenreLeadingMovie.isActive = false
        allGenreLeadingTvShow.isActive = true
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allGenreLeadingTvShow.constant = topButtonSpacing * 2
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.isHidden = false
            self.tvShowButton.alpha = 1
            self.tvShowButton.transformIcon = true
            self.tvShowButton.scale = true
        }) { _ in
            self.allGenreLeadingMovie.constant = -50
        }
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, animations: {
            self.moviesButton.alpha = 0
            self.myListButton.alpha = 0
            self.allGenreButton.alpha = 1
            self.allGenreButton.isHidden = false
            self.layoutIfNeeded()
        }) { _ in
            self.moviesButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    func animateGenresDeselected() {
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
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.tvShowButton.transformIcon = false
            self.tvShowButton.scale = false
            self.moviesButton.transformIcon = false
            self.moviesButton.scale = false
            self.myListButton.transformIcon = false
            self.myListButton.scale = false
        }) { _ in
            self.allGenreLeadingMovie.constant = -50
            PersistentManager.shared.currentGenre = PersistentManager.shared.allGenre.id
            self.allGenreButton.setTitle(title: Strings.allGenres)
        }
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, animations: {
            self.moviesButton.alpha = 1
            self.myListButton.alpha = 1
            self.tvShowButton.alpha = 1
            self.tvShowButton.isHidden = false
            self.moviesButton.isHidden = false
            self.myListButton.isHidden = false
            self.allGenreButton.alpha = 0
            self.layoutIfNeeded()
        }) { _ in
            self.allGenreButton.isHidden = true
        }
    }
    
    func animateMoviesSelected() {
        allGenreLeadingTvShow.isActive = false
        allGenreLeadingMovie.isActive = true
        moviesButton.deactiveWidthConstraints()
        moviesButtonLeading.constant = topButtonSpacing
        myListButtonLeading.constant = myListButtonLeading.constant - 50
        allGenreLeadingMovie.constant = topButtonSpacing * 2
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.moviesButton.isHidden = false
            self.moviesButton.alpha = 1
            self.moviesButton.transformIcon = true
            self.moviesButton.scale = true
        }) { _ in
            self.allGenreLeadingTvShow.constant = -50
        }
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, animations: {
            self.tvShowButton.alpha = 0
            self.myListButton.alpha = 0
            self.allGenreButton.alpha = 1
            self.allGenreButton.isHidden = false
            self.layoutIfNeeded()
        }) { _ in
            self.tvShowButton.isHidden = true
            self.myListButton.isHidden = true
        }
    }
    
    func animateMyListSelected() {
        myListButton.deactiveWidthConstraints()
        moviesButtonLeading.constant = moviesButtonLeading.constant - 50
        myListButtonLeading.constant = topButtonSpacing
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.myListButton.isHidden = false
            self.myListButton.alpha = 1
            self.myListButton.transformIcon = true
            self.myListButton.scale = true
        }) { _ in
        }
        
        UIView.animate(withDuration: categoryTypeButtonAnimationDuration, animations: {
            self.tvShowButton.alpha = 0
            self.moviesButton.alpha = 0
            self.allGenreButton.alpha = 0
            self.allGenreButton.isHidden = true
            self.layoutIfNeeded()
        }) { _ in
            self.tvShowButton.isHidden = true
            self.moviesButton.isHidden = true
        }
    }
}

extension CategoryAnimationView {
    func setAllGenreButtonTitle(title: String) {
        allGenreButton.setTitle(title: title)
    }
}

extension CategoryAnimationView {
    @objc private func tvShowTapped() {
        delegate?.tvShowTapped()
    }
    
    @objc private func moviesTapped() {
        delegate?.moviesTapped()
    }
    
    @objc private func mylistTapped() {
        delegate?.mylistTapped()
    }
    
    @objc private func genreTapped() {
        delegate?.genreTapped()
    }
}
