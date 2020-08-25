//
//  HeaderMovieDetailCell.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Lottie

class HeaderMovieDetailCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var myListLottieView: AnimationView!
    @IBOutlet weak var mylistButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var directorView: UIView!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var actionTitleStackView: UIStackView!
    @IBOutlet weak var durationLabel: UILabel!
    
    var viewModel: HeaderMovieDetailViewModel!
    private var bag = DisposeBag()
    private let addToMyListTrigger = PublishSubject<Bool>()

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        playButton.backgroundColor = .red
        playButton.layer.cornerRadius = 3
        myListLottieView.animation = Animation.named("icon-addList")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: HeaderMovieDetailViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let input = HeaderMovieDetailViewModel.Input(addToMyListTrigger: addToMyListTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.media
            .map { $0.posterPath }
            .map { ImageHelper.shared.pathToURL(path: $0, imageSize: .w200)}
            .drive(bannerImageView.rx.imageURL)
            .disposed(by: bag)
        
        output.media
            .map { $0.overview }
            .drive(overviewLabel.rx.text)
            .disposed(by: bag)
        
        output.movieDetail
            .map { [weak self] movieDetail -> String? in
                guard let self = self else { return nil }
                guard let casts = movieDetail?.cast, casts.count > 0 else {
                    self.castView.isHidden = true
                    return nil
                }
                let castNames = Array(casts.compactMap { $0.name }.prefix(4))
                self.castView.isHidden = castNames.count == 0
                return castNames.count > 0 ? String(format: Strings.castListFormat, castNames.joined(separator: ", ")) : nil
            }
            .drive(castLabel.rx.text)
            .disposed(by: bag)
        
        output.media
            .map { $0.releaseDate ?? "" }
            .map { DateHelper.getYear(dateString: $0) }
            .drive(yearLabel.rx.text)
            .disposed(by: bag)
        
        output.movieDetail
            .map { $0?.movieDetail?.runtime }
            .map { DateHelper.minutesToHourMinutes(minutes: $0)}
            .drive(durationLabel.rx.text)
            .disposed(by: bag)
        
        output.movieDetail
            .map { $0?.movieDetail?.runtime == nil }
            .drive(durationLabel.rx.isHidden)
            .disposed(by: bag)
        
        output.movieDetail
            .map { [weak self] movieDetail -> String? in
                guard let self = self else { return nil }
                guard let crews = movieDetail?.crew, crews.count > 0 else {
                    self.directorView.isHidden = true
                    return nil
                }
                let crewNames = crews.filter { $0.job?.lowercased() == CrewRole.director.rawValue.lowercased() }.compactMap { $0.name }
                self.directorView.isHidden = crewNames.count == 0
                return crewNames.count > 0 ? String(format: Strings.directorListFormat, crewNames.joined(separator: ", ")) : nil
            }
            .drive(directorLabel.rx.text)
            .disposed(by: bag)
        
        output.media
            .map { $0.id }
            .drive(onNext: { [weak self] id in
                guard let self = self, let id = id else { return }
                self.myListLottieView.currentProgress = PersistentManager.shared.watchList.compactMap { $0.id }.contains(id) ? 1 : 0
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

        mylistButton.rx.tap
            .withLatestFrom(output.loading)
            .filter { !$0 }
            .map { [weak self] _ -> Bool in
                guard let self = self else {
                    fatalError()
                }
                return !MovieHelper.isMyList(movie: self.viewModel.media)
            }
            .subscribe(onNext: { [weak self] watchList in
                guard let self = self else { return }
                self.handleAnimation(isMyList: watchList)
                self.addToMyListTrigger.onNext(watchList)
            })
            .disposed(by: bag)
    }
}

extension HeaderMovieDetailCell {
    func update(isMyList: Bool, mediaID: Int) {
        guard viewModel.media.id != mediaID else {
            return
        }
        if isMyList {
            myListLottieView.play(fromProgress: 0, toProgress: 1, loopMode: .none, completion: nil)
        } else {
            myListLottieView.play(fromProgress: 1, toProgress: 0, loopMode: .none, completion: nil)
        }
    }
    
    private func handleAddToMyList() {
        if !PersistentManager.shared.watchList.compactMap({ $0.id }).contains(self.viewModel.media.id ?? -1) {
            var watchList = PersistentManager.shared.watchList
            watchList.insert(self.viewModel.media, at: 0)
            PersistentManager.shared.watchList = watchList
            NotificationCenter.default.post(name: .didAddToMyList,
                                            object: nil,
                                            userInfo: [
                                                "is_mylist": true,
                                                "movie_id": viewModel.media.id])
        }
    }
    
    private func handleRemoveFromMyList() {
        if let index = PersistentManager.shared.watchList.firstIndex(where: { movie -> Bool in
            return movie.id == self.viewModel.media.id && movie.id != nil
        }) {
            var watchList = PersistentManager.shared.watchList
            watchList.remove(at: index)
            PersistentManager.shared.watchList = watchList
            NotificationCenter.default.post(name: .didAddToMyList,
                                            object: nil,
                                            userInfo: [
                                                "is_mylist": false,
                                                "movie_id": viewModel.media.id])
        }
    }
    
    private func handleAnimation(isMyList: Bool) {
        if isMyList {
            self.myListLottieView.play(fromProgress: 0,
                                          toProgress: 1,
                                          loopMode: .none,
                                          completion: nil)
        } else {
            self.myListLottieView.play(fromProgress: 1,
                                          toProgress: 0,
                                          loopMode: .none,
                                          completion: nil)
        }
    }
}
