//
//  HeaderMovieDetailViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderMovieDetailViewModel: ViewModel {
    let media: Media
    private var movieDetailData: MovieDetailDataModel?
    
    init(media: Media, detail: MovieDetailDataModel?) {
        self.media = media
        self.movieDetailData = detail
    }
    
    func transform(input: Input) -> Output {
        let userInfoService = UserInfoService()
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let addToMyListResult = input.addToMyListTrigger.flatMapLatest { [unowned self] watchList -> Driver<Bool> in
            print("my list tapped")
            return self.addToWatchList(accountID: userInfoService.getAccountID() ?? -1, watchList: watchList)
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .map { _ in watchList }
                .asDriver(onErrorJustReturn: false)
        }
        
        return Output(media: .just(media),
                      movieDetail: .just(movieDetailData),
                      addToMyListResult: addToMyListResult,
                      loading: activityIndicator.asDriver())
    }
    
    private func addToWatchList(accountID: Int, watchList: Bool) -> Observable<BaseSuccessResult> {
        return HostAPIClient.performApiNetworkCall(
            router: .addToWatchlist(accountID: accountID,
                                    mediaType: .movie,
                                    mediaID: media.id ?? -1,
                                    watchList: watchList),
            type: BaseSuccessResult.self
        )
    }
}

extension HeaderMovieDetailViewModel {
    struct Input {
        var addToMyListTrigger: Driver<Bool>
    }
    
    struct Output {
        var media: Driver<Media>
        var movieDetail: Driver<MovieDetailDataModel?>
        var addToMyListResult: Driver<Bool>
        var loading: Driver<Bool>
    }
}
