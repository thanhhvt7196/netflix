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
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let results = input.fetchTrigger.flatMapLatest { [unowned self] _ in
            return self.getPopularMovies()
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .compactMap { $0.results}
                .asDriver(onErrorJustReturn: [])
        }
        return Output(fetchResult: results, error: errorTracker.asDriver(), indicator: activityIndicator.asDriver())
    }
    
    private func getPopularMovies() -> Observable<PopularMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularMovies, type: PopularMoviesResponse.self)
    }
}

extension HomeViewModel {
    struct Input {
        var fetchTrigger: Driver<Void>
    }
    
    struct Output {
        var fetchResult: Driver<[Movie]>
        var error: Driver<Error>
        var indicator: Driver<Bool>
    }
}
