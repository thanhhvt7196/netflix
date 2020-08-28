//
//  MoviesCategoryViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/8/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesCategoryViewModel: ViewModel {
    private let errorTracker = ErrorTracker()
    var rowContentOffSets: [IndexPath: CGPoint] = [:] {
        didSet {
            print(rowContentOffSets)
        }
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let allGenreData = input.fetchDataTrigger.filter { $0 == nil || $0 == 0 }.flatMapLatest { [unowned self] _ in
            return self.getMoviesAllData()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let specificGenreData = input.fetchDataTrigger.compactMap { $0 }.filter { $0 != 0 }.flatMapLatest { [unowned self] genreID -> Driver<MovieWithGenreDataModel> in
            return self.getMoviesDataWithGenre(genre: genreID)
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let allGenreDataSource = allGenreData.asObservable()
            .map { [weak self] movieCategoryData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: movieCategoryData)
            }

        let specificGenreDataSource = specificGenreData.asObservable()
            .map { [weak self] movieWithGenreData -> [HomeCategoryViewSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(data: movieWithGenreData)
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

extension MoviesCategoryViewModel {
    private func getMoviesDataWithGenre(genre: Int) -> Observable<MovieWithGenreDataModel> {
        let popularMovieList = discoverMovie(sortBy: .popularityDesc, genre: genre)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let mostFavoriteMovieList = discoverMovie(sortBy: .voteAverageDesc, genre: genre)
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let topGrossingMovieList = discoverMovie(sortBy: .revenueDesc, genre: genre)
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let koreanMovieList = discoverMovie(genre: genre, originalLanguage: .ko)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let westernMovieList = discoverMovie(genre: genre, originalLanguage: .en)
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let japaneseMovieList = discoverMovie(genre: genre, originalLanguage: .ja)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let chineseMovieList = discoverMovie(originalLanguage: .zh)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(popularMovieList,
                                  mostFavoriteMovieList,
                                  topGrossingMovieList,
                                  westernMovieList,
                                  koreanMovieList,
                                  japaneseMovieList,
                                  chineseMovieList)
            .map { popularMovieList, mostFavoriteMovieList, topGrossingMovieList, westernMovieList, koreanMovieList, japaneseMovieList, chineseMovieList  -> MovieWithGenreDataModel in
                return MovieWithGenreDataModel(
                    popularMovieList: popularMovieList,
                    mostFavoriteMovieList: mostFavoriteMovieList,
                    topGrossingMovieList: topGrossingMovieList,
                    westernMovieList: westernMovieList,
                    koreanMovieList: koreanMovieList,
                    japaneseMovieList: japaneseMovieList,
                    chineseMovieList: chineseMovieList
                )
        }
        return data
    }
    
    private func getMoviesAllData() -> Observable<MovieCategoryDataModel> {
        let nowPlayingList = getNowPlayingList(page: 1)
                                .map { $0.results ?? [] }
                                .trackError(errorTracker)
                                .catchErrorJustReturn([])
        
        let popularMovieList = getPopularMovieList(page: 1)
                                .map { $0.results ?? [] }
                                .trackError(errorTracker)
                                .catchErrorJustReturn([])
        
        let topRatedMovieList = getTopRatedMovieList(page: 1)
                                    .map { $0.results ?? [] }
                                    .trackError(errorTracker)
                                    .catchErrorJustReturn([])
        
        let trendingTodayMovieList = getTrendingTodayMovieList()
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
                
        let upcomingMovieList = getUpcomingMovieList(page: 1)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let mostFavoriteMovieList = discoverMovie(sortBy: .voteAverageDesc)
                                        .trackError(errorTracker)
                                        .map { $0.results ?? [] }
                                        .catchErrorJustReturn([])
        
        let topGrossingMovieList = discoverMovie(sortBy: .revenueDesc)
                                    .trackError(errorTracker)
                                    .map { $0.results ?? [] }
                                    .catchErrorJustReturn([])
        
        let data = Observable.zip(nowPlayingList,
                                  popularMovieList,
                                  topRatedMovieList,
                                  trendingTodayMovieList,
                                  upcomingMovieList,
                                  mostFavoriteMovieList,
                                  topGrossingMovieList)
            .map { nowPlayingList, popularMovieList, topRatedMovieList, trendingTodayMovieList, upcomingMovieList, mostFavoriteMovieList, topGrossingMovieList  -> MovieCategoryDataModel in
                return MovieCategoryDataModel(
                    nowPlayingList: nowPlayingList,
                    popularMovieList: popularMovieList,
                    topRatedMovieList: topRatedMovieList,
                    trendingMovieList: trendingTodayMovieList,
                    upcomingMovieList: upcomingMovieList,
                    mostFavoriteMovieList: mostFavoriteMovieList,
                    topGrossingMovieList: topGrossingMovieList
                )
                
        }
        return data
    }
    
    private func mapToDataSource(data: MovieWithGenreDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.popularMovieList.first {
            sections.append(
                .headerMovie(title: nil,
                             items: [.headerMovie(movie: headerMovie)]
                )
            )
        }
        if data.popularMovieList.count > 0 {
            if data.popularMovieList.suffix(data.popularMovieList.count - 1).count > 0 {
                sections.append(
                    .popularMovies(title: Strings.popularMovies,
                                   items: [.previewList(movies: Array(data.popularMovieList.suffix(data.popularMovieList.count - 1)),
                                                        mediaType: .movie)]
                    )
                )
            }
        }
        if data.mostFavoriteMovieList.count > 0 {
            sections.append(
                .mostFavoriteTVShow(title: Strings.mostFavoriteMovies,
                                    items: [.moviesListItem(movies: data.mostFavoriteMovieList,
                                                            mediaType: .movie)]
                )
            )
        }
        if data.westernMovieList.count > 0 {
            sections.append(
                .WesternTVShow(title: Strings.westernMovies,
                               items: [.moviesListItem(movies: data.westernMovieList,
                                                       mediaType: .movie)]
                )
            )
        }
        if data.koreanMovieList.count > 0 {
            sections.append(
                .koreanTVShow(title: Strings.koreanMovies,
                              items: [.moviesListItem(movies: data.koreanMovieList,
                                                      mediaType: .movie)]
                )
            )
        }
        if data.japaneseMovieList.count > 0 {
            sections.append(
                .japaneseTVShow(title: Strings.japaneseMovies,
                                items: [.moviesListItem(movies: data.japaneseMovieList,
                                                        mediaType: .movie)]
                )
            )
        }
        if data.chineseMovieList.count > 0 {
            sections.append(
                .chineseMovie(title: Strings.chineseMovies,
                              items: [.moviesListItem(movies: data.chineseMovieList,
                                                      mediaType: .movie)]
                )
            )
        }
        return sections
    }
    
    private func mapToDataSource(data: MovieCategoryDataModel) -> [HomeCategoryViewSectionModel] {
        var sections = [HomeCategoryViewSectionModel]()
        if let headerMovie = data.popularMovieList.first {
            sections.append(
                .headerMovie(title: nil, items: [.headerMovie(movie: headerMovie)]
                )
            )
        }
        if data.popularMovieList.count > 0 {
            if data.popularMovieList.suffix(data.popularMovieList.count - 1).count > 0 {
                sections.append(
                    .popularMovies(title: Strings.popularMovies,
                                   items: [.previewList(movies: Array(data.popularMovieList.suffix(data.popularMovieList.count - 1)),
                                                        mediaType: .movie)]
                    )
                )
            }
        }
        if data.nowPlayingList.count > 0 {
            sections.append(
                .nowPlayingMovie(title: Strings.nowPlaying,
                                 items: [.moviesListItem(movies: data.nowPlayingList,
                                                         mediaType: .movie)]
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
        if data.trendingMovieList.count > 0 {
            sections.append(
                .trendingToday(title: Strings.trendingToday,
                               items: [.moviesListItem(movies: data.trendingMovieList,
                                                       mediaType: .movie)]
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
        if data.mostFavoriteMovieList.count > 0 {
            sections.append(
                .mostFavoriteTVShow(title: Strings.mostFavoriteMovies,
                                    items: [.moviesListItem(movies: data.mostFavoriteMovieList,
                                                            mediaType: .movie)]
                )
            )
        }
        if data.topGrossingMovieList.count > 0 {
            sections.append(
                .WesternTVShow(title: Strings.topGrossingMovies,
                               items: [.moviesListItem(movies: data.topGrossingMovieList,
                                                       mediaType: .movie)]
                )
            )
        }
        return sections
    }
}

extension MoviesCategoryViewModel {
    private func getNowPlayingList(page: Int) -> Observable<NowPlayingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getMovieNowPlayingList(page: page),
            type: NowPlayingMovieResponse.self
        )
    }
    
    private func getPopularMovieList(page: Int) -> Observable<PopularMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getPopularMovies(page: page),
            type: PopularMoviesResponse.self
        )
    }
    
    private func getTopRatedMovieList(page: Int) -> Observable<TopRatedMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTopRatedMoviesList(page: page),
            type: TopRatedMovieResponse.self
        )
    }
    
    private func getUpcomingMovieList(page: Int) -> Observable<UpcomingMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getUpcomingMoviesList(page: page),
            type: UpcomingMovieResponse.self
        )
    }
    
    private func getTrendingTodayMovieList() -> Observable<TrendingMoviesResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getTrendingMedia(mediaType: .movie,
                                      period: .day),
            type: TrendingMoviesResponse.self
        )
    }
    
    private func discoverMovie(sortBy: MovieSortType? = nil,
                               page: Int = 1,
                               genre: Int? = nil,
                               includeVideo: Bool = true,
                               originalLanguage: LanguageCodes? = nil)
        -> Observable<DiscoverMovieResponse> {
        return HostAPIClient.performApiNetworkCall(
                    router: .discoverMovie(sortBy: sortBy,
                                           page: page,
                                           genre: genre,
                                           includeVideo: includeVideo,
                                           originalLanguage: originalLanguage),
                    type: DiscoverMovieResponse.self
        )
    }
}

extension MoviesCategoryViewModel {
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
