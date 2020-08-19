//
//  MovieDetailViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel: ViewModel {
    private let movie: Media
    
    private let bag = DisposeBag()
    private let errorTracker = ErrorTracker()
    private let dataSource: BehaviorRelay<[MovieDetailSectionModel]>
    private var movieDetail: MovieDetailDataModel?
    
    init(movie: Media) {
        self.movie = movie
        self.dataSource = BehaviorRelay<[MovieDetailSectionModel]>(value: [.headerDetail(item: [.headerMovie(media: movie, detail: nil)])])
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let movieDetailData = input.getMovieDetailTrigger.flatMapLatest { [unowned self] _ in
            return self.getMovieDetailData()
                .trackActivity(activityIndicator)
                .asDriver(onErrorJustReturn: nil)
            }
        
        movieDetailData
            .map { [weak self] detail -> [MovieDetailSectionModel] in
                guard let self = self else { return [] }
                self.movieDetail = detail
                return self.mapToDataSource(detail: detail, selectedIndex: input.selectedContent.value)
            }
            .drive(dataSource)
            .disposed(by: bag)
        
        input.selectedContent
            .distinctUntilChanged()
            .map { [weak self] selectedIndex -> [MovieDetailSectionModel] in
                guard let self = self else { return [] }
                return self.mapToDataSource(detail: self.movieDetail, selectedIndex: selectedIndex)
            }
            .bind(to: dataSource)
            .disposed(by: bag)
        
        return Output(loading: activityIndicator.asDriver(),
                      dataSource: dataSource)
    }
}

extension MovieDetailViewModel {
    private func mapToDataSource(detail: MovieDetailDataModel?, selectedIndex: Int) -> [MovieDetailSectionModel] {
        var sections = [MovieDetailSectionModel]()
        sections.append(
            .headerDetail(item: [.headerMovie(media: movie, detail: detail)])
        )
        
        var titles = [String]()
        
        let videos = detail?.videos ?? []
        if videos.count > 0 {
            titles.append(Strings.episodes.uppercased())
        }
        let recommendations = ArrayHelper.combine(arrays: [detail?.recommendations ?? [], detail?.similarMedia ?? []])
        if recommendations.count > 0 {
            titles.append(Strings.moreLikeThis.uppercased())
        }

        let videoItems = videos.map { MovieDetailSectionItem.episode(video: $0) }
        let recommendationItems = Array(recommendations.chunked(into: 3).prefix(2)).map { MovieDetailSectionItem.recommendMedia(medias: $0) }
        
        if !(videoItems.count == 0 && recommendationItems.count == 0) {
            var items = [[MovieDetailSectionItem]]()
            if videoItems.count > 0 {
                items.append(videoItems)
            }
            if recommendationItems.count > 0 {
                items.append(recommendationItems)
            }
            if items.indices.contains(selectedIndex) {
                sections.append(.pager(titles: titles, item: items[selectedIndex]))
            }
        }
        
        return sections
    }
        
    private func getMovieDetailData() -> Observable<MovieDetailDataModel?> {
        let movieDetail = getMovieDetail()
                            .trackError(errorTracker)
                            .catchErrorJustReturn(nil)
        
        let videos = getVideos()
                        .trackError(errorTracker)
                        .map { $0?.results ?? [] }
                        .catchErrorJustReturn([])
        
        let recommendations = getRecommendations()
                                .trackError(errorTracker)
                                .map { $0?.results ?? [] }
                                .catchErrorJustReturn([])
        
        let similarMovies = getSimilarMovies()
                                .trackError(errorTracker)
                                .map { $0.results ?? [] }
                                .catchErrorJustReturn([])
        
        let credits = getCredits()
                        .trackError(errorTracker)
                        .catchErrorJustReturn(nil)
        
        return Observable.zip(movieDetail,
                              videos,
                              recommendations,
                              similarMovies,
                              credits)
            .map { movieDetail, videos, recommendations, similarMovies, credits -> MovieDetailDataModel in
            return MovieDetailDataModel(movieDetail: movieDetail,
                                        videos: videos,
                                        recommendations: recommendations,
                                        similarMedia: similarMovies,
                                        cast: credits?.cast ?? [],
                                        crew: credits?.crew ?? [])
        }
    }
}

extension MovieDetailViewModel {
    private func getMovieDetail() -> Observable<MovieDetailModel?> {
        return HostAPIClient.performApiNetworkCall(
            router: .getMovieDetail(id: movie.id ?? 0),
            type: MovieDetailModel?.self
        )
    }
    
    private func getVideos() -> Observable<VideosResponse?> {
        return HostAPIClient.performApiNetworkCall(
            router: .getVideos(mediaID: movie.id ?? 0, mediaType: .movie),
            type: VideosResponse?.self
        )
    }
    
    private func getRecommendations() -> Observable<RecommendationsResponse?> {
        return HostAPIClient.performApiNetworkCall(
            router: .getRecommendations(mediaID: movie.id ?? 0, mediaType: .movie),
            type: RecommendationsResponse?.self
        )
    }
    
    private func getSimilarMovies() -> Observable<SimilarMediaResponse> {
        return HostAPIClient.performApiNetworkCall(
            router: .getSimilarMedia(mediaID: movie.id ?? 0, mediaType: .movie),
            type: SimilarMediaResponse.self
        )
    }
    
    private func getCredits() -> Observable<CreditsResponse?> {
        return HostAPIClient.performApiNetworkCall(
            router: .getCredits(mediaID: movie.id ?? 0, mediaType: .movie),
            type: CreditsResponse?.self
        )
    }
}

extension MovieDetailViewModel {
    struct Input {
        var getMovieDetailTrigger: Driver<Void>
        var selectedContent: BehaviorRelay<Int>
    }
    
    struct Output {
        var loading: Driver<Bool>
        var dataSource: BehaviorRelay<[MovieDetailSectionModel]>
    }
}
