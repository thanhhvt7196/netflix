//
//  HeaderMovieTableViewCell.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Lottie

class HeaderMovieTableViewCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var myListAnimationView: AnimationView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var myListButton: UIButton!
    
    var viewModel: HeaderMovieViewModel!
    private var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        playView.layer.cornerRadius = 2
        let addListAnimation = Animation.named("icon-addList")
        myListAnimationView.animation = addListAnimation
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: HeaderMovieViewModel) {
        self.viewModel = viewModel
        bindData()
        handleAction()
    }
    
    private func bindData() {
        let input = HeaderMovieViewModel.Input(
            showMovieDetailTrigger: infoButton.rx.tap.asDriver(),
            addToMyListTrigger: myListButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)

        output.movie
            .map { $0.posterPath }
            .map { ImageHelper.shared.pathToURL(path: $0, imageSize: .original)}
            .drive(posterImageView.rx.imageURL)
            .disposed(by: bag)
        
        output.movie
            .map { movie -> [String] in
                if let ids = movie.genreIds, ids.count > 0 {
                    let allMovieGenres = MovieGenreRealmObject.getAllGenres() ?? []
                    let allTVShowsGenres = TVGenreRealmObject.getAllGenres() ?? []
                    let genreIds = Set((allTVShowsGenres + allMovieGenres).compactMap { $0.id }).intersection(Set(ids))
                    let genreNames = (allTVShowsGenres + allMovieGenres).filter { genre -> Bool in
                        return genreIds.contains(genre.id ?? 0)
                    }
                    return Array(Set(genreNames.compactMap { $0.name }))
                }
                
                if let genres = movie.genres, genres.count > 0 {
                    return genres.compactMap { $0.name }
                }
                return []
            }
            .map { $0.joined(separator: " • ")}
            .drive(genreLabel.rx.text)
            .disposed(by: bag)
        
        output.movie.map { $0.id }
            .drive(onNext: { [weak self] id in
                guard let self = self, let id = id else { return }
                self.myListAnimationView.currentProgress = PersistentManager.shared.watchList.compactMap { $0.id }.contains(id) ? 1 : 0
            })
            .disposed(by: bag)
        
        output.error
            .drive(onNext: { error in
                UIApplication.shared.currentWindow?.rootViewController?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.addToMyListResult
            .drive(onNext: { [weak self] isMyList in
                guard let self = self else { return }
                if isMyList {
                    if !PersistentManager.shared.watchList.compactMap({ $0.id }).contains(self.viewModel.movie.id ?? -1) {
                        var watchList = PersistentManager.shared.watchList
                        watchList.insert(self.viewModel.movie, at: 0)
                        PersistentManager.shared.watchList = watchList
                        self.myListAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .none, completion: nil)
                        NotificationCenter.default.post(name: .didAddToMyList,
                                                        object: nil,
                                                        userInfo: [
                                                            "is_mylist": true,
                                                            "movie_id": self.viewModel.movie.id])
                    }
                } else {
                    if let index = PersistentManager.shared.watchList.firstIndex(where: { movie -> Bool in
                        return movie.id == self.viewModel.movie.id && movie.id != nil
                    }) {
                        var watchList = PersistentManager.shared.watchList
                        watchList.remove(at: index)
                        PersistentManager.shared.watchList = watchList
                        self.myListAnimationView.play(fromProgress: 1, toProgress: 0, loopMode: .none, completion: nil)
                        NotificationCenter.default.post(name: .didAddToMyList,
                                                        object: nil,
                                                        userInfo: [
                                                            "is_mylist": false,
                                                            "movie_id": self.viewModel.movie.id])
                    }
                }
            })
            .disposed(by: bag)
        
        output.loading.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
    
    private func handleAction() {
        
    }
}

extension HeaderMovieTableViewCell {
    func update(isMyList: Bool, movieID: Int) {
        guard viewModel.movie.id == movieID else {
            return
        }
        if isMyList {
            myListAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .none, completion: nil)
        } else {
            myListAnimationView.play(fromProgress: 1, toProgress: 0, loopMode: .none, completion: nil)
        }
    }
}
