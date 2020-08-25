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
    private let addToMyListTrigger = PublishSubject<Bool>()

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
    }
    
    private func bindData() {
        let input = HeaderMovieViewModel.Input(
            showMovieDetailTrigger: infoButton.rx.tap.asDriver(),
            addToMyListTrigger: addToMyListTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)

        output.movie
            .map { $0.posterPath }
            .map { ImageHelper.shared.pathToURL(path: $0, imageSize: .original)}
            .drive(posterImageView.rx.imageURL())
            .disposed(by: bag)
        
        output.movie
            .map { MovieHelper.getGenresString(movie: $0) }
            .drive(genreLabel.rx.text)
            .disposed(by: bag)
        
        output.movie.map { $0.id }
            .drive(onNext: { [weak self] id in
                guard let self = self, let id = id else { return }
                self.myListAnimationView.currentProgress = PersistentManager.shared.watchList.compactMap { $0.id }.contains(id) ? 1 : 0
            })
            .disposed(by: bag)
        
        output.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleAnimation(isMyList: MovieHelper.isMyList(movie: self.viewModel.movie))
            })
            .disposed(by: bag)
        
        output.addToMyListResult
            .drive(onNext: { [weak self] isMyList in
                guard let self = self else { return }
                if isMyList {
                    self.handleAddToMyList()
                } else {
                    self.handleRemoveFromMyList()
                }
            })
            .disposed(by: bag)
        
        myListButton.rx.tap
            .withLatestFrom(output.loading)
            .filter { !$0 }
            .map { [weak self] _ -> Bool in
                guard let self = self else {
                    fatalError()
                }
                return !MovieHelper.isMyList(movie: self.viewModel.movie)
            }
            .subscribe(onNext: { [weak self] watchList in
                guard let self = self else { return }
                self.handleAnimation(isMyList: watchList)
                self.addToMyListTrigger.onNext(watchList)
            })
            .disposed(by: bag)
    }
}

extension HeaderMovieTableViewCell {
    func update(isMyList: Bool, movieID: Int) {
        guard viewModel.movie.id == movieID else {
            return
        }
        if isMyList {
            guard myListAnimationView.currentProgress != 1 else {
                return
            }
            myListAnimationView.play(fromProgress: myListAnimationView.currentProgress, toProgress: 1, loopMode: .none, completion: nil)
        } else {
            guard myListAnimationView.currentProgress != 0 else {
                return
            }
            myListAnimationView.currentProgress = 0
        }
    }
    
    private func handleAddToMyList() {
        if !PersistentManager.shared.watchList.compactMap({ $0.id }).contains(self.viewModel.movie.id ?? -1) {
            var watchList = PersistentManager.shared.watchList
            watchList.insert(self.viewModel.movie, at: 0)
            PersistentManager.shared.watchList = watchList
            NotificationCenter.default.post(name: .didAddToMyList,
                                            object: nil,
                                            userInfo: [
                                                "is_mylist": true,
                                                "movie_id": viewModel.movie.id])
        }
    }
    
    private func handleRemoveFromMyList() {
        if let index = PersistentManager.shared.watchList.firstIndex(where: { movie -> Bool in
            return movie.id == self.viewModel.movie.id && movie.id != nil
        }) {
            var watchList = PersistentManager.shared.watchList
            watchList.remove(at: index)
            PersistentManager.shared.watchList = watchList
            NotificationCenter.default.post(name: .didAddToMyList,
                                            object: nil,
                                            userInfo: [
                                                "is_mylist": false,
                                                "movie_id": viewModel.movie.id])
        }
    }
    
    private func handleAnimation(isMyList: Bool) {
        if isMyList {
            self.myListAnimationView.play(fromProgress: 0,
                                          toProgress: 1,
                                          loopMode: .none,
                                          completion: nil)
        } else {
            self.myListAnimationView.play(fromProgress: 1,
                                          toProgress: 0,
                                          loopMode: .none,
                                          completion: nil)
        }
    }
}
