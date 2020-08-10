//
//  HeaderMovieViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderMovieViewModel: ViewModel {
    var movie: Movie
    var mediaType: MediaType
    private let bag = DisposeBag()
    
    init(movie: Movie, mediaType: MediaType) {
        self.movie = movie
        self.mediaType = mediaType
    }
    
    func transform(input: Input) -> Output {
        let userInfoService = UserInfoService()
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        input.showMovieDetailTrigger
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: self.movie))
            })
            .disposed(by: bag)
        
        let addToMyListResult = input.addToMyListTrigger.flatMapLatest { [unowned self] _  in
            return self.addToWatchList(accountID: userInfoService.getAccountID() ?? -1, watchList: !self.isMyList)
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .map { [weak self] _ -> Bool in
                    guard let self = self else { return false }
                    return !self.isMyList
                }
                .asDriverOnErrorJustComplete()
        }
        return Output(movie: .just(movie),
                      addToMyListResult: addToMyListResult,
                      error: errorTracker.asDriver(),
                      loading: activityIndicator.asDriver())
    }
    
    private func addToWatchList(accountID: Int, watchList: Bool) -> Observable<BaseSuccessResult> {
        return HostAPIClient.performApiNetworkCall(router: .addToWatchlist(accountID: accountID, mediaType: mediaType, mediaID: movie.id ?? -1, watchList: watchList), type: BaseSuccessResult.self)
    }
}

extension HeaderMovieViewModel {
    private var isMyList: Bool {
        return PersistentManager.shared.watchList.compactMap { $0.id }.contains(movie.id ?? -1)
    }
}

extension HeaderMovieViewModel {
    struct Input {
        var showMovieDetailTrigger: Driver<Void>
        var addToMyListTrigger: Driver<Void>
    }
    
    struct Output {
        var movie: Driver<Movie>
        var addToMyListResult: Driver<Bool>
        var error: Driver<Error>
        var loading: Driver<Bool>
    }
}
