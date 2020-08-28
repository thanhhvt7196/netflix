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
    private let errorTracker = ErrorTracker()
    var rowContentOffSets: [IndexPath: CGPoint] = [:] {
        didSet {
            print(rowContentOffSets)
        }
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let allGenreData = input.fetchDataTrigger.filter { $0 == nil || $0 == 0 }.flatMapLatest { [unowned self] _ in
            return self.getTVShowAllData()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let specificGenreData = input.fetchDataTrigger.compactMap { $0 }.filter { $0 != 0 }.flatMapLatest { [unowned self] genreID -> Driver<TVShowWithGenresDataModel> in
            return self.getTVShowDataWithGenre(genre: genreID)
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let allGenreDataSource = allGenreData.asObservable()
            .map { [weak self] tvShowCategoryData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: tvShowCategoryData)
            }
        
        let specificGenreDataSource = specificGenreData.asObservable()
            .map { [weak self] tvShowWithGenreData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: tvShowWithGenreData)
            }
        
        let clearData = input.clearDataTrigger.asObservable()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.rowContentOffSets = [:]
            })
            .map { _ -> [HomeCategoryViewSectionModel] in
                return []
            }
        
        let dataSource = Observable.merge(allGenreDataSource,
                                          specificGenreDataSource,
                                          clearData)
                                    .asDriver(onErrorJustReturn: [])

        return Output(dataSource: dataSource,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
}

extension TVShowCategoryViewModel {
    private func getTVShowDataWithGenre(genre: Int) -> Observable<TVShowWithGenresDataModel> {
        let ontheAirTVShowList = discoverTV(sortBy: .firstAirDateDesc, genre: genre)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let popularTVShowsList = discoverTV(sortBy: .popularityDesc, genre: genre)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let mostFavoriteTVShowList = discoverTV(sortBy: .voteAverageDesc, genre: genre)
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let koreanTVShowList = discoverTV(genre: genre, originalLanguage: .ko)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let westernTVShowList = discoverTV(genre: genre, originalLanguage: .en)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let japaneseTVShowList = discoverTV(genre: genre, originalLanguage: .ja)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let chineseTVShowList = discoverTV(genre: genre, originalLanguage: .zh)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(ontheAirTVShowList,
                                  popularTVShowsList,
                                  mostFavoriteTVShowList,
                                  westernTVShowList,
                                  koreanTVShowList,
                                  japaneseTVShowList,
                                  chineseTVShowList)
            .map { ontheAirTVShowList, popularTVShowsList, mostFavoriteTVShowList, westernTVShowList, koreanTVShowList, japaneseTVShowList, chineseTVShowList  -> TVShowWithGenresDataModel in
                return TVShowWithGenresDataModel(
                    popularTVShowList: popularTVShowsList,
                    mostFavoriteTVShowList: mostFavoriteTVShowList,
                    koreanTVShowList: koreanTVShowList,
                    WesternTVShowList: westernTVShowList,
                    japaneseTVShowList: japaneseTVShowList,
                    chineseTVShowList: chineseTVShowList
                )
        }
        return data
    }
    
    private func getTVShowAllData() -> Observable<TVShowCategoryDataModel> {
        let tvShowAiringTodayList = getTVShowAiringToday(page: 1)
                                        .map { $0.results ?? [] }
                                        .trackError(errorTracker)
                                        .catchErrorJustReturn([])
        
        let popularTVShowsList = getPopularTVShows(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let topRatedTVShowsList = getTopRatedTVShows(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let mostFavoriteTVShowList = discoverTV(sortBy: .voteAverageDesc)
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let trendingTodayTVShowList = getTrendingTodayTVShow()
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let koreanTVShowList = discoverTV(originalLanguage: .ko)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let westernTVShowList = discoverTV(originalLanguage: .en)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let chineseTVShowList = discoverTV(originalLanguage: .zh)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(tvShowAiringTodayList,
                                  popularTVShowsList,
                                  topRatedTVShowsList,
                                  mostFavoriteTVShowList,
                                  trendingTodayTVShowList,
                                  westernTVShowList,
                                  koreanTVShowList,
                                  chineseTVShowList)
            .map { tvShowAiringTodayList, popularTVShowsList, topRatedTVShowsList, mostFavoriteTVShowList, trendingTodayTVShowList, westernTVShowList, koreanTVShowList, chineseTVShowList -> TVShowCategoryDataModel in
                return TVShowCategoryDataModel(
                    airingTodayList: tvShowAiringTodayList,
                    popularTVShowList: popularTVShowsList,
                    topRatedTVShowList: topRatedTVShowsList,
                    mostFavoriteTVShowList: mostFavoriteTVShowList,
                    trendingTodayTVShowList: trendingTodayTVShowList,
                    koreanTVShowList: koreanTVShowList,
                    westernTVShowList: westernTVShowList,
                    chineseTVShowList: chineseTVShowList
                )
        }
        return data
    }
    
    private func mapToDataSource(data: TVShowWithGenresDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.popularTVShowList.first {
            sections.append(
                .headerMovie(title: nil,
                             items: [.headerMovie(movie: headerMovie)]
                )
            )
        }
        if data.popularTVShowList.count > 0 {
            if data.popularTVShowList.suffix(data.popularTVShowList.count - 1).count > 0 {
                sections.append(
                    .popularTVShows(title: Strings.popularTVShows,
                                    items: [.previewList(movies: Array(data.popularTVShowList.suffix(data.popularTVShowList.count - 1)),
                                                         mediaType: .movie)]
                    )
                )
            }
        }
        
        if data.mostFavoriteTVShowList.count > 0 {
            sections.append(
                .mostFavoriteTVShow(title: Strings.mostFavoriteTVShow,
                                    items: [.moviesListItem(movies: data.mostFavoriteTVShowList,
                                                            mediaType: .tv)]
                )
            )
        }
        if data.WesternTVShowList.count > 0 {
            sections.append(
                .WesternTVShow(title: Strings.westernTVShow,
                               items: [.moviesListItem(movies: data.WesternTVShowList,
                                                       mediaType: .tv)]
                )
            )
        }
        if data.koreanTVShowList.count > 0 {
            sections.append(
                .koreanTVShow(title: Strings.kDramas,
                              items: [.moviesListItem(movies: data.koreanTVShowList,
                                                      mediaType: .tv)]
                )
            )
        }
        if data.japaneseTVShowList.count > 0 {
            sections.append(
                .japaneseTVShow(title: Strings.madeInJapan,
                                items: [.moviesListItem(movies: data.japaneseTVShowList,
                                                        mediaType: .tv)]
                )
            )
        }
        if data.chineseTVShowList.count > 0 {
            sections.append(
                .chineseTVShow(title: Strings.chineseSeries,
                               items: [.moviesListItem(movies: data.chineseTVShowList,
                                                       mediaType: .tv)]
                )
            )
        }
        return sections
    }
    
    private func mapToDataSource(data: TVShowCategoryDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.popularTVShowList.first {
            sections.append(
                .headerMovie(title: nil,
                             items: [.headerMovie(movie: headerMovie)]
                )
            )
        }
        if data.popularTVShowList.count > 0 {
            if data.popularTVShowList.suffix(data.popularTVShowList.count - 1).count > 0 {
                sections.append(
                    .popularTVShows(title: Strings.popularTVShows,
                                    items: [.previewList(movies: Array(data.popularTVShowList.suffix(data.popularTVShowList.count - 1)),
                                                         mediaType: .tv)]
                    )
                )
            }
        }
        if data.airingTodayList.count > 0 {
            sections.append(
                .tvShowAiringToday(title: Strings.airingToday,
                                   items: [.moviesListItem(movies: data.airingTodayList,
                                                           mediaType: .tv)]
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
        if data.mostFavoriteTVShowList.count > 0 {
            sections.append(
                .mostFavoriteTVShow(title: Strings.mostFavoriteTVShow,
                                    items: [.moviesListItem(movies: data.mostFavoriteTVShowList,
                                                            mediaType: .tv)]
                )
            )
        }
        if data.trendingTodayTVShowList.count > 0 {
            sections.append(
                .trendingToday(title: Strings.trendingToday,
                               items: [.moviesListItem(movies: data.trendingTodayTVShowList, mediaType: .tv)]
                )
            )
        }
        if data.westernTVShowList.count > 0 {
            sections.append(
                .WesternTVShow(title: Strings.westernTVShow,
                               items: [.moviesListItem(movies: data.westernTVShowList,
                                                       mediaType: .tv)]
                )
            )
        }
        if data.koreanTVShowList.count > 0 {
            sections.append(
                .koreanTVShow(title: Strings.kDramas,
                              items: [.moviesListItem(movies: data.koreanTVShowList,
                                                      mediaType: .tv)]
                )
            )
        }
        if data.chineseTVShowList.count > 0 {
            sections.append(
                .chineseTVShow(title: Strings.chineseSeries,
                               items: [.moviesListItem(movies: data.chineseTVShowList,
                                                       mediaType: .tv)]
                )
            )
        }
        return sections
    }
}

extension TVShowCategoryViewModel {
    private func getTVShowAiringToday(page: Int) -> Observable<AiringTodayTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getAiringTodayTVShowList(page: page),
            type: AiringTodayTVShowResponse.self
        )
    }
        
    private func getPopularTVShows(page: Int) -> Observable<PopularTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getPopularTVShows(page: page),
            type: PopularTVShowResponse.self
        )
    }
    
    private func getTopRatedTVShows(page: Int) -> Observable<TopRatedTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTopRatedTvShowsList(page: page),
            type: TopRatedTVShowResponse.self
        )
    }
    
    private  func getTrendingTodayTVShow() -> Observable<TrendingTVShowResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTrendingMedia(mediaType: .tv, period: .week),
            type: TrendingTVShowResponse.self
        )
    }
    
    private func discoverTV(sortBy: TVShowSortType? = nil,
                            page: Int = 1,
                            genre: Int? = nil,
                            originalLanguage: LanguageCodes? = nil)
        -> Observable<DiscoverTVResponse> {
        return HostAPIClient.performApiNetworkCall(
                    router: .discoverTV(sortBy: sortBy,
                                        page: page,
                                        genre: genre,
                                        originalLanguage: originalLanguage),
                    type: DiscoverTVResponse.self
        )
    }
}

extension TVShowCategoryViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Int?>
        var clearDataTrigger: Driver<Void>
    }
    
    struct Output {
        var dataSource: Driver<[HomeCategoryViewSectionModel]>
        var error: Driver<Error>
        var indicator: Driver<Bool>
    }
}
