//
//  MyListViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyListViewModel: ViewModel {
    private let bag = DisposeBag()
    private let errorTracker = ErrorTracker()
    let isTabbarItem: Bool
    
    init(isTabbarItem: Bool) {
        self.isTabbarItem = isTabbarItem
    }
    
    func transform(input: Input) -> Output {
        let userInfoService = UserInfoService()
        let activityIndicator = ActivityIndicator()
        let mylist = BehaviorRelay<[Movie]>(value: [])
        
        let myListData = input.fetchDataTrigger.flatMapLatest { [unowned self] _ in
            return self.getMyListData(accountID: userInfoService.getAccountID() ?? -1)
                .do(onNext: { watchList in
                    PersistentManager.shared.watchList = watchList
                })
                .trackActivity(activityIndicator)
                .asDriver(onErrorJustReturn: [])
            
        }
        
        let clearDataTrigger = input.clearDataTrigger.map { _ in [Movie]() }
        Driver.merge(myListData, clearDataTrigger).drive(mylist).disposed(by: bag)
        
        return Output(mylist: mylist.asDriver(),
                      error: errorTracker.asDriver(),
                      loading: activityIndicator.asDriver())
    }
}

extension MyListViewModel {
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
    
    private func getMyListData(accountID: Int) -> Observable<[Movie]> {
        let movieWatchList = getMovieWatchList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let tvShowWatchList = getTVShowWatchList(accountID: accountID)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        return Observable.zip(tvShowWatchList, movieWatchList)
                        .map { [$0, $1] }
                        .map { ArrayHelper.combine(arrays: $0) }
    }
}

extension MyListViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Void>
        var clearDataTrigger: Driver<Void>
    }
    
    struct Output {
        var mylist: Driver<[Movie]>
        var error: Driver<Error>
        var loading: Driver<Bool>
    }
}
