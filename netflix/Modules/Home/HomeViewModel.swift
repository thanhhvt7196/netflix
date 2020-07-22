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
        let results = input.fetchTrigger.flatMapLatest { [unowned self] page in
            return self.getPopularMovies(page: page)
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .compactMap { $0.results}
                .asDriver(onErrorJustReturn: [])
        }
        
        let genres = input.getGenresTrigger.flatMapLatest { [unowned self] _ in
            return self.getTVShowGenres()
                .trackError(errorTracker)
                .compactMap { $0.genres }
                .asDriver(onErrorJustReturn: [])
        }
        return Output(fetchResult: results, error: errorTracker.asDriver(), indicator: activityIndicator.asDriver(), genres: genres)
    }
    
    private func getPopularMovies(page: Int) -> Observable<PopularMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularMovies(page: page), type: PopularMoviesResponse.self)
    }
    
    private func getTVShowGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTvShowGenresList, type: GenresResponse.self)
    }
}

extension HomeViewModel {
    struct Input {
        var fetchTrigger: Driver<Int>
        var getGenresTrigger: Driver<Void>
    }
    
    struct Output {
        var fetchResult: Driver<[Movie]>
        var error: Driver<Error>
        var indicator: Driver<Bool>
        var genres: Driver<[Genre]>
    }
}
