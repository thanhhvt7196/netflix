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
    private let loading = BehaviorRelay<Bool>(value: false)
    private let errorTracker = ErrorTracker()
    
    var rowContentOffSets: [IndexPath: CGPoint] = [:] 
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let clearData = input.clearDataTrigger.asObservable()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.rowContentOffSets = [:]
            })
            .map { _ -> [HomeCategoryViewSectionModel] in
                return []
            }
        
        let dataSource = input.fetchDataTrigger
            .asObservable()
            .flatMapLatest { [unowned self] _ in
                return self.getHomeCategoryData()
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .map { [weak self] homeCategoryData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: homeCategoryData)
            }
        .merge(with: clearData)
        .asDriver(onErrorJustReturn: [])
                
        return Output(dataSource: dataSource,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
}

extension HomeCategoryViewModel {
    private func getHomeCategoryData() -> Observable<HomeCategoryDataModel> {
        let mostFavoriteMovieList = getMostFavoriteMovieList(page: 1)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
                
        let tvShowAiringTodayList = getTVShowAiringToday(page: 1)
                                        .map { $0.results ?? [] }
                                        .trackError(errorTracker)
                                        .catchErrorJustReturn([])
        
        let popularMoviesList = getPopularMovies(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let popularTVShowsList = getPopularTVShows(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let topRatedMoviesList = getTopRatedMovies(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let topRatedTVShowsList = getTopRatedTVShows(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let upcomingMoviesList = getUpcomingMovies(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let tvShowOnTheAirList = getTVShowOnTheAir(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(mostFavoriteMovieList,
                                  tvShowAiringTodayList,
                                  popularMoviesList,
                                  popularTVShowsList,
                                  topRatedMoviesList,
                                  topRatedTVShowsList,
                                  upcomingMoviesList,
                                  tvShowOnTheAirList)
        
        let homeCategoryData = data.map { mostFavoriteMostList, tvShowAiringTodayList, popularMoviesList, popularTVShowsList, topRatedMoviesList, topRatedTVShowsList, upcomingMoviesList, tvShowOnTheAirList -> HomeCategoryDataModel in
            return HomeCategoryDataModel(
                mostFavoriteMovieList: mostFavoriteMostList,
                tvShowAiringToday: tvShowAiringTodayList,
                popularMovieList: popularMoviesList,
                popularTVShowList: popularTVShowsList,
                topRatedMovieList: topRatedMoviesList,
                topRatedTVShowList: topRatedTVShowsList,
                upcomingMovieList: upcomingMoviesList,
                tvShowLatestReleaseList: tvShowOnTheAirList
            )
        }
        return homeCategoryData
    }
    
    private func mapToDataSource(data: HomeCategoryDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.popularMovieList.first {
            sections.append(
                .headerMovie(
                    title: nil,
                    items: [.headerMovie(movie: headerMovie)]
                )
            )
        }
        if data.popularMovieList.count > 0 {
            if data.popularMovieList.suffix(data.popularMovieList.count - 1).count > 0 {
                sections.append(
                    .popularMovies(
                        title: Strings.popularMovies,
                        items: [.previewList(movies: Array(data.popularMovieList.suffix(data.popularMovieList.count - 1)),
                                             mediaType: .movie)]
                    )
                )
            }
        }
        
        if data.tvShowAiringToday.count > 0 {
            sections.append(
                .tvShowAiringToday(title: Strings.airingToday,
                                   items: [.moviesListItem(movies: data.tvShowAiringToday,
                                                           mediaType: .tv)]
                )
            )
        }
        if data.tvShowLatestReleaseList.count > 0 {
            sections.append(
                .latestReleaseTVShow(title: Strings.latestReleases,
                                     items: [.moviesListItem(movies: data.tvShowLatestReleaseList,
                                                             mediaType: .tv)]
                )
            )
        }
        if data.mostFavoriteMovieList.count > 0 {
            sections.append(
                .mostFavoriteMovie(title: Strings.mostFavoriteMovies,
                               items: [.moviesListItem(movies: data.mostFavoriteMovieList,
                                                       mediaType: .movie)]
                )
            )
        }
        if data.popularTVShowList.count > 0 {
            sections.append(
                .popularTVShows(title: Strings.popularTVShows,
                                items: [.moviesListItem(movies: data.popularTVShowList,
                                                        mediaType: .tv)]
                )
            )
        }
        if data.topRatedMovieList.count > 0 {
            sections.append(
                .topRatedMovies(title: Strings.topRatedMovies,
                                items: [.moviesListItem(movies: data.topRatedMovieList,
                                                        mediaType: .movie)]
                )
            )
        }
        if data.topRatedTVShowList.count > 0 {
            sections.append(
                .topRatedTVShows(title: Strings.topRatedTVShows,
                                 items: [.moviesListItem(movies: data.topRatedTVShowList,
                                                         mediaType: .tv)]
                )
            )
        }
        if data.upcomingMovieList.count > 0 {
            sections.append(
                .upcomingMovie(title: Strings.upcomingMovies,
                               items: [.moviesListItem(movies: data.upcomingMovieList,
                                                       mediaType: .movie)]
                )
            )
        }
        
        return sections
    }
}

extension HomeCategoryViewModel {
    private func getMostFavoriteMovieList(page: Int) -> Observable<DiscoverMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .discoverMovie(sortBy: .voteAverageDesc,
                                   page: 1, genre: nil,
                                   includeVideo: true,
                                   originalLanguage: nil),
            type: DiscoverMovieResponse.self
        )
    }
    
    private func getTVShowAiringToday(page: Int) -> Observable<AiringTodayTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getAiringTodayTVShowList(page: page),
            type: AiringTodayTVShowResponse.self
        )
    }
    
    private func getPopularMovies(page: Int) -> Observable<PopularMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getPopularMovies(page: page),
            type: PopularMoviesResponse.self
        )
    }
    
    private func getPopularTVShows(page: Int) -> Observable<PopularTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getPopularTVShows(page: page),
            type: PopularTVShowResponse.self
        )
    }
    
    private func getTopRatedMovies(page: Int) -> Observable<TopRatedMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTopRatedMoviesList(page: page),
            type: TopRatedMovieResponse.self
        )
    }
    
    private func getTopRatedTVShows(page: Int) -> Observable<TopRatedTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTopRatedTvShowsList(page: page),
            type: TopRatedTVShowResponse.self
        )
    }
    
    private func getUpcomingMovies(page: Int) -> Observable<UpcomingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getUpcomingMoviesList(page: page),
            type: UpcomingMovieResponse.self
        )
    }
    
    private func getTVShowOnTheAir(page: Int) -> Observable<TVShowOnTheAirResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTVShowOnTheAir(page: page),
            type: TVShowOnTheAirResponse.self
        )
    }
}

extension HomeCategoryViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Void>
        var clearDataTrigger: Driver<Void>
    }
    
    struct Output {
        var dataSource: Driver<[HomeCategoryViewSectionModel]>
        var error: Driver<Error>
        var indicator: Driver<Bool>
    }
}
