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
        
//        let TVGenres = input.getGenresTrigger.flatMapLatest { [unowned self] _ in
//            return self.getTVShowGenres()
//                .trackError(errorTracker)
//                .map { $0.genres ?? [] }
//                .asDriver(onErrorJustReturn: [])
//        }
//
//        let movieGenres = input.getGenresTrigger.flatMapLatest { [unowned self] _ in
//            return self.getMovieGenres()
//                .trackError(errorTracker)
//                .map { $0.genres ?? [] }
//                .asDriver(onErrorJustReturn: [])
//        }
//        return Output(error: errorTracker.asDriver(),
//                      indicator: activityIndicator.asDriver(),
//                      TVGenres: TVGenres,
//                      movieGenres: movieGenres)
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
        
        let data = Observable.zip(tvShowGenres,
                                  movieGenres,
                                  tvShowWatchList,
                                  movieWatchList)
            .map { tvShowGenres, movieGenres, tvShowWatchList, movieWatchList -> HomeGeneralData in
                return HomeGeneralData(tvGenres: tvShowGenres,
                                       movieGenres: movieGenres,
                                       tvShowWatchList: tvShowWatchList,
                                       movieWatchList: movieWatchList)
        }
        return data
    }
}

extension HomeViewModel {
    private func getTVShowGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTvShowGenresList, type: GenresResponse.self)
    }
    
    private func getMovieGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getMovieGenresList, type: GenresResponse.self)
    }
    
    private func getMovieWatchList(accountID: Int) -> Observable<MovieWatchListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getMovieWatchList(accountID: accountID), type: MovieWatchListResponse.self)
    }
    
    private func getTVShowWatchList(accountID: Int) -> Observable<TVShowWatchListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTVShowWatchList(accountID: accountID), type: TVShowWatchListResponse.self)
    }
}

extension HomeViewModel {
    struct Input {
        var getGeneralDataTrigger: Driver<Void>
    }
    
    struct Output {
        var error: Driver<Error>
        var indicator: Driver<Bool>
//        var TVGenres: Driver<[Genre]>
//        var movieGenres: Driver<[Genre]>
        var homeGeneralData: Driver<HomeGeneralData>
    }
}
