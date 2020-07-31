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
    private let bag = DisposeBag()
    let dataSource = BehaviorRelay<[HomeCategoryViewSectionModel]>(value: [])
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        input.clearDataTrigger.map { _ in [] }.drive(dataSource).disposed(by: bag)
        let nowPlayingList = input.fetchDataTrigger.flatMapLatest { [unowned self] _ in
            return self.getMovieNowplaying(page: 1)
                .trackError(errorTracker)
                .compactMap { $0.results }
                .asDriver(onErrorJustReturn: [])
        }
        
        let tvShowAiringTodayList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getTVShowAiringToday(page: 1)
            
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let popularMoviesList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getPopularMovies(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let popularTVShowsList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getPopularTVShows(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let topRatedMoviesList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getTopRatedMovies(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let topRatedTVShowsList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getTopRatedTVShows(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let upcomingMoviesList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getUpcomingMovies(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let tvShowOnTheAirList = input.fetchDataTrigger.flatMapLatest { [unowned self] in
            return self.getTVShowOnTheAir(page: 1)
                
                .compactMap { $0.results }
                .trackError(errorTracker)
                .asDriver(onErrorJustReturn: [])
        }
        
        let data = Observable.zip(nowPlayingList.asObservable(),
                                  tvShowAiringTodayList.asObservable(),
                                  popularMoviesList.asObservable(),
                                  popularTVShowsList.asObservable(),
                                  topRatedMoviesList.asObservable(),
                                  topRatedTVShowsList.asObservable(),
                                  upcomingMoviesList.asObservable(),
                                  tvShowOnTheAirList.asObservable())
                            .trackActivity(activityIndicator)
        
        data.map { nowPlayingList, tvShowAiringTodayList, popularMoviesList, popularTVShowsList, topRatedMoviesList, topRatedTVShowsList, upcomingMoviesList, tvShowOnTheAirList -> [HomeCategoryViewSectionModel] in
                var sections = [HomeCategoryViewSectionModel]()
                if let headerMovie = nowPlayingList.first {
                    sections.append(.headerMovie(title: nil, items: [.headerMovie(movie: headerMovie)]))
                }
                if nowPlayingList.count > 0 {
                    if nowPlayingList.suffix(nowPlayingList.count - 1).count > 0 {
                        sections.append(.nowPlayingMovie(title: Strings.nowPlaying, items: [.previewList(movies: Array(nowPlayingList.suffix(nowPlayingList.count - 1)))]))
                    }
                }
                
                if tvShowAiringTodayList.count > 0 {
                    sections.append(.tvShowAiringToday(title: Strings.airingToday, items: [.moviesListItem(movies: tvShowAiringTodayList)]))
                }
                if popularMoviesList.count > 0 {
                    sections.append(.popularMovies(title: Strings.popularMovies, items: [.moviesListItem(movies: popularMoviesList)]))
                }
                if popularTVShowsList.count > 0 {
                    sections.append(.popularTVShows(title: Strings.popularTVShows, items: [.moviesListItem(movies: popularTVShowsList)]))
                }
                if topRatedMoviesList.count > 0 {
                    sections.append(.topRatedMovies(title: Strings.topRatedMovies, items: [.moviesListItem(movies: topRatedMoviesList)]))
                }
                if topRatedTVShowsList.count > 0 {
                    sections.append(.topRatedTVShows(title: Strings.topRatedTVShows, items: [.moviesListItem(movies: topRatedTVShowsList)]))
                }
                if upcomingMoviesList.count > 0 {
                    sections.append(.upcomingMovie(title: Strings.upcomingMovies, items: [.moviesListItem(movies: upcomingMoviesList)]))
                }
                if tvShowOnTheAirList.count > 0 {
                    sections.append(.tvShowOnTheAir(title: Strings.onTheAir, items: [.moviesListItem(movies: tvShowOnTheAirList)]))
                }
                return sections
        }
        .bind(to: dataSource).disposed(by: bag)
        return Output(dataSource: dataSource,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
    
    private func getMovieNowplaying(page: Int) -> Observable<NowPlayingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getMovieNowPlayingList(page: page), type: NowPlayingMovieResponse.self)
    }
    
    private func getTVShowAiringToday(page: Int) -> Observable<AiringTodayTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAiringTodayTVShowList(page: page), type: AiringTodayTVShowResponse.self)
    }
    
    private func getPopularMovies(page: Int) -> Observable<PopularMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularMovies(page: page), type: PopularMoviesResponse.self)
    }
    
    private func getPopularTVShows(page: Int) -> Observable<PopularTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularTVShows(page: page), type: PopularTVShowResponse.self)
    }
    
    private func getTopRatedMovies(page: Int) -> Observable<TopRatedMovieResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTopRatedMoviesList(page: page), type: TopRatedMovieResponse.self)
    }
    
    private func getTopRatedTVShows(page: Int) -> Observable<TopRatedTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTopRatedTvShowsList(page: page), type: TopRatedTVShowResponse.self)
    }
    
    private func getUpcomingMovies(page: Int) -> Observable<UpcomingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getUpcomingMoviesList(page: page), type: UpcomingMovieResponse.self)
    }
    
    private func getTVShowOnTheAir(page: Int) -> Observable<TVShowOnTheAirResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTVShowOnTheAir(page: page), type: TVShowOnTheAirResponse.self)
    }
}

extension HomeCategoryViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Void>
        var clearDataTrigger: Driver<Void>
    }
    
    struct Output {
        var dataSource: BehaviorRelay<[HomeCategoryViewSectionModel]>
        var error: Driver<Error>
        var indicator: Driver<Bool>
    }
}
