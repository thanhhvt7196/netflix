//
//  HomeViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class HomeViewModel: ViewModel {
    private let bag = DisposeBag()
    private let errorTracker = ErrorTracker()
    private var currentPage = 1
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let homeGeneralData = input.getGeneralDataTrigger.flatMapLatest { [unowned self] _ -> Driver<HomeGeneralData> in
            guard let accountID = AccountDetailObject.getAccountDetail()?.id else {
                return .empty()
            }
            return self.getHomeGeneralData(accountID: accountID)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        
        return Output(error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver(),
                      homeGeneralData: homeGeneralData)
    }
}

extension HomeViewModel {
    private func getHomeGeneralData(accountID: Int) -> Observable<HomeGeneralData> {
        let tvShowGenres = getTVShowGenres()
                                .trackError(errorTracker)
                                .map { $0.genres ?? [] }
                                .catchErrorJustReturn([])
        
        let movieGenres = getMovieGenres()
                                .trackError(errorTracker)
                                .map { $0.genres ?? [] }
                                .catchErrorJustReturn([])
        
        let movieWatchList = getMovieWatchList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let tvShowWatchList = getTVShowWatchList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let movieFavoriteList = getMovieFavoriteList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let tvShowFavoriteList = getTVShowFavoriteList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let data = Observable.zip(tvShowGenres,
                                  movieGenres,
                                  tvShowWatchList,
                                  movieWatchList,
                                  tvShowFavoriteList,
                                  movieFavoriteList)
            .map { tvShowGenres, movieGenres, tvShowWatchList, movieWatchList, tvShowFavoriteList, movieFavoriteList -> HomeGeneralData in
                return HomeGeneralData(tvGenres: tvShowGenres,
                                       movieGenres: movieGenres,
                                       tvShowWatchList: tvShowWatchList,
                                       movieWatchList: movieWatchList,
                                       tvShowFavoriteList: tvShowFavoriteList,
                                       movieFavoriteList: movieFavoriteList)
        }
        return data
    }
}

extension HomeViewModel {
    private func getTVShowGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTvShowGenresList,
            type: GenresResponse.self
        )
    }
    
    private func getMovieGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getMovieGenresList,
            type: GenresResponse.self
        )
    }
    
    private func getMovieWatchList(accountID: Int) -> Observable<MovieWatchListResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getMovieWatchList(accountID: accountID),
            type: MovieWatchListResponse.self
        )
    }
    
    private func getTVShowWatchList(accountID: Int) -> Observable<TVShowWatchListResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTVShowWatchList(accountID: accountID),
            type: TVShowWatchListResponse.self
        )
    }
    
    private func getMovieFavoriteList(accountID: Int) -> Observable<MovieFavoriteListResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getMovieFavoriteList(accountID: accountID),
            type: MovieFavoriteListResponse.self
        )
    }
    
    private func getTVShowFavoriteList(accountID: Int) -> Observable<TVShowFavoriteListResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTVShowFavoriteList(accountID: accountID),
            type: TVShowFavoriteListResponse.self
        )
    }
}

extension HomeViewModel {
    struct Input {
        var getGeneralDataTrigger: Driver<Void>
    }
    
    struct Output {
        var error: Driver<Error>
        var indicator: Driver<Bool>
        var homeGeneralData: Driver<HomeGeneralData>
    }
}
