//
//  TVShowCategoryViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/1/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TVShowCategoryViewModel: ViewModel {
    private let bag = DisposeBag()
    let dataSource = BehaviorRelay<[HomeCategoryViewSectionModel]>(value: [])
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        input.clearDataTrigger.map { _ in [] }.drive(dataSource).disposed(by: bag)
        
        let activityIndicator = ActivityIndicator()
        let data = input.fetchDataTrigger.flatMapLatest { [unowned self] _ in
            return self.getTVShowAllData()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        data.map { [weak self] tvShowCategoryData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: tvShowCategoryData)
            }
            .drive(dataSource)
            .disposed(by: bag)
        
        return Output(dataSource: dataSource,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
}

extension TVShowCategoryViewModel {
    private func getTVShowDataWithGenre(genre: Genre) -> Observable<TVShowWithGenresDataModel> {
        let ontheAirTVShowList = discoverTV(sortBy: .firstAirDateDesc, genre: genre)
                                    .compactMap { $0.results }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let popularTVShowsList = discoverTV(sortBy: .popularityDesc, genre: genre)
                                    .compactMap { $0.results }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let mostFavoriteTVShowList = discoverTV(sortBy: .voteAverageDesc, genre: genre)
                                        .trackError(errorTracker)
                                        .compactMap { $0.results }
                                        .catchErrorJustReturn([])
        
        let koreanTVShowList = discoverTV(genre: genre, originalLanguage: .ko)
                                    .trackError(errorTracker)
                                    .compactMap { $0.results }
                                    .catchErrorJustReturn([])
        
        let USTVShowList = discoverTV(genre: genre, originalLanguage: .en)
                                .trackError(errorTracker)
                                .compactMap { $0.results }
                                .catchErrorJustReturn([])
        
        let japaneseTVShowList = discoverTV(genre: genre, originalLanguage: .ja)
                                    .trackError(errorTracker)
                                    .compactMap { $0.results }
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(ontheAirTVShowList,
                                  popularTVShowsList,
                                  mostFavoriteTVShowList,
                                  USTVShowList,
                                  koreanTVShowList,
                                  japaneseTVShowList)
            .map { ontheAirTVShowList, popularTVShowsList, mostFavoriteTVShowList, USTVShowList, koreanTVShowList, japaneseTVShowList  -> TVShowWithGenresDataModel in
                return TVShowWithGenresDataModel(
                    popularTVShowList: popularTVShowsList,
                    mostFavoriteTVShowList: mostFavoriteTVShowList,
                    latestReleaseTVShowList: ontheAirTVShowList,
                    koreanTVShowList: koreanTVShowList,
                    USTVShowList: USTVShowList,
                    japaneseTVShowList: japaneseTVShowList
                )
        }
        return data
    }
    
    private func getTVShowAllData() -> Observable<TVShowCategoryDataModel> {
        let tvShowAiringTodayList = getTVShowAiringToday(page: 1)
                                        .compactMap { $0.results }
                                        .trackError(errorTracker)
                                        .catchErrorJustReturn([])
        
        let popularTVShowsList = getPopularTVShows(page: 1)
                                    .compactMap { $0.results }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let topRatedTVShowsList = getTopRatedTVShows(page: 1)
                                    .compactMap { $0.results }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let ontheAirTVShowList = getTVShowOnTheAir(page: 1)
                                    .compactMap { $0.results }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let latestTV = getLatestTV()
                        .trackError(errorTracker)
                        .catchErrorJustReturn(nil)
        
        let mostFavoriteTVShowList = discoverTV(sortBy: .voteAverageDesc)
                                        .trackError(errorTracker)
                                        .compactMap { $0.results }
                                        .catchErrorJustReturn([])
        
        let koreanTVShowList = discoverTV(originalLanguage: .ko)
                                    .trackError(errorTracker)
                                    .compactMap { $0.results }
                                    .catchErrorJustReturn([])
        
        let USTVShowList = discoverTV(originalLanguage: .en)
                                .trackError(errorTracker)
                                .compactMap { $0.results }
                                .catchErrorJustReturn([])
        
        let data = Observable.zip(latestTV,
                                  tvShowAiringTodayList,
                                  ontheAirTVShowList,
                                  popularTVShowsList,
                                  topRatedTVShowsList,
                                  mostFavoriteTVShowList,
                                  USTVShowList,
                                  koreanTVShowList)
            .map { latestTV, tvShowAiringTodayList, ontheAirTVShowList, popularTVShowsList, topRatedTVShowsList, mostFavoriteTVShowList, USTVShowList, koreanTVShowList  -> TVShowCategoryDataModel in
                return TVShowCategoryDataModel(
                    latestTV: latestTV,
                    airingTodayList: tvShowAiringTodayList,
                    popularTVShowList: popularTVShowsList,
                    topRatedTVShowList: topRatedTVShowsList,
                    tvShowLatestReleaseList: ontheAirTVShowList,
                    mostFavoriteTVShowList: mostFavoriteTVShowList,
                    koreanTVShowList: koreanTVShowList,
                    USTVShowList: USTVShowList
                )
        }
        return data
    }
    
    private func mapToDataSource(data: TVShowWithGenresDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.latestReleaseTVShowList.first {
            sections.append(.headerMovie(title: nil, items: [.headerMovie(movie: headerMovie)]))
        }
        if data.latestReleaseTVShowList.count > 0 {
            if data.latestReleaseTVShowList.suffix(data.latestReleaseTVShowList.count - 1).count > 0 {
                sections.append(.tvShowOnTheAir(title: Strings.latestReleases, items: [.previewList(movies: Array(data.latestReleaseTVShowList.suffix(data.latestReleaseTVShowList.count - 1)))]))
            }
        }
        if data.popularTVShowList.count > 0 {
            sections.append(.popularTVShows(title: Strings.popularTVShows, items: [.moviesListItem(movies: data.popularTVShowList)]))
        }
        if data.mostFavoriteTVShowList.count > 0 {
            sections.append(.mostFavoriteTVShow(title: Strings.mostFavoriteTVShow, items: [.moviesListItem(movies: data.mostFavoriteTVShowList)]))
        }
        if data.USTVShowList.count > 0 {
            sections.append(.USTVShow(title: Strings.USTVShow, items: [.moviesListItem(movies: data.USTVShowList)]))
        }
        if data.koreanTVShowList.count > 0 {
            sections.append(.koreanTVShow(title: Strings.KDramas, items: [.moviesListItem(movies: data.koreanTVShowList)]))
        }
        if data.japaneseTVShowList.count > 0 {
            sections.append(.japaneseTVShow(title: Strings.japaneseSeries, items: [.moviesListItem(movies: data.japaneseTVShowList)]))
        }
        return sections
    }
    
    private func mapToDataSource(data: TVShowCategoryDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let latestTV = data.latestTV {
            sections.append(.headerMovie(title: nil, items: [.headerMovie(movie: latestTV)]))
        }
        if data.airingTodayList.count > 0 {
            sections.append(.tvShowAiringToday(title: Strings.airingToday, items: [.moviesListItem(movies: data.airingTodayList)]))
        }
        if data.tvShowLatestReleaseList.count > 0 {
            sections.append(.tvShowOnTheAir(title: Strings.latestReleases, items: [.moviesListItem(movies: data.tvShowLatestReleaseList)]))
        }
        if data.popularTVShowList.count > 0 {
            sections.append(.popularTVShows(title: Strings.popularTVShows, items: [.moviesListItem(movies: data.popularTVShowList)]))
        }
        if data.topRatedTVShowList.count > 0 {
            sections.append(.topRatedTVShows(title: Strings.topRatedTVShows, items: [.moviesListItem(movies: data.topRatedTVShowList)]))
        }
        if data.mostFavoriteTVShowList.count > 0 {
            sections.append(.mostFavoriteTVShow(title: Strings.mostFavoriteTVShow, items: [.moviesListItem(movies: data.mostFavoriteTVShowList)]))
        }
        if data.USTVShowList.count > 0 {
            sections.append(.USTVShow(title: Strings.USTVShow, items: [.moviesListItem(movies: data.USTVShowList)]))
        }
        if data.koreanTVShowList.count > 0 {
            sections.append(.koreanTVShow(title: Strings.KDramas, items: [.moviesListItem(movies: data.koreanTVShowList)]))
        }
        return sections
    }
}

extension TVShowCategoryViewModel {
    private func getTVShowAiringToday(page: Int) -> Observable<AiringTodayTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAiringTodayTVShowList(page: page), type: AiringTodayTVShowResponse.self)
    }
        
    private func getPopularTVShows(page: Int) -> Observable<PopularTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularTVShows(page: page), type: PopularTVShowResponse.self)
    }
    
    private func getTopRatedTVShows(page: Int) -> Observable<TopRatedTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTopRatedTvShowsList(page: page), type: TopRatedTVShowResponse.self)
    }
    
    private func getTVShowOnTheAir(page: Int) -> Observable<TVShowOnTheAirResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getTVShowOnTheAir(page: page), type: TVShowOnTheAirResponse.self)
    }
    
    private func discoverTV(sortBy: MovieSortType? = nil, page: Int = 1, genre: Genre? = nil, originalLanguage: LanguageCodes? = nil) -> Observable<DiscoverTVResponse> {
        return HostAPIClient.performApiNetworkCall(router: .discoverTV(sortBy: sortBy, page: page, genre: genre, originalLanguage: originalLanguage), type: DiscoverTVResponse.self)
    }
    
    private func getLatestTV() -> Observable<Movie?> {
        return HostAPIClient.performApiNetworkCall(router: .getLatestTV, type: Movie?.self)
    }
}

extension TVShowCategoryViewModel {
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
