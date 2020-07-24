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
        
        let TVGenres = input.getGenresTrigger.flatMapLatest { [unowned self] _ in
            return self.getTVShowGenres()
                .trackError(errorTracker)
                .compactMap { $0.genres }
                .asDriver(onErrorJustReturn: [])
        }
        
        let movieGenres = input.getGenresTrigger.flatMapLatest { [unowned self] _ in
            return self.getMovieGenres()
                .trackError(errorTracker)
                .compactMap { $0.genres }
                .asDriver(onErrorJustReturn: [])
        }
        return Output(error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver(),
                      TVGenres: TVGenres,
                      movieGenres: movieGenres)
    }
    
    private func getTVShowGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTvShowGenresList, type: GenresResponse.self)
    }
    
    private func getMovieGenres() -> Observable<GenresResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getMovieGenresList, type: GenresResponse.self)
    }
}

extension HomeViewModel {
    struct Input {
        var getGenresTrigger: Driver<Void>
    }
    
    struct Output {
        var error: Driver<Error>
        var indicator: Driver<Bool>
        var TVGenres: Driver<[Genre]>
        var movieGenres: Driver<[Genre]>
    }
}
