//
//  HomeCategoryViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeCategoryViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let nowPlayingList = input.fetchDataTrigger.flatMapLatest { [unowned self] _ in
            return self.getMovieNowplaying()
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        return Output(nowPlayingList: nowPlayingList,
                      error: errorTracker.asDriver())
    }
    
    private func getMovieNowplaying() -> Observable<NowPlayingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getMovieNowPlayingList, type: NowPlayingMovieResponse.self)
    }
}

extension HomeCategoryViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Void>
    }
    
    struct Output {
        var nowPlayingList: Driver<[Movie]>
        var error: Driver<Error>
    }
}
