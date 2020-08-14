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
    private let mediaType: MediaType
    
    private let bag = DisposeBag()
    private let errorTracker = ErrorTracker()
    
    init(movie: Media, mediaType: MediaType) {
        self.movie = movie
        self.mediaType = mediaType
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let movieData = input.getMovieDetailTrigger.flatMapLatest { [unowned self] _ in
            return self.getMovieDetailData()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        return Output(tempMedia: .just(movie), movie: movieData)
    }
}

extension MovieDetailViewModel {
    private func getMovieDetailData() -> Observable<MovieDetailDataModel> {
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
        
        return Observable.zip(movieDetail,
                              videos,
                              recommendations)
            .map { movieDetail, videos, recommendations -> MovieDetailDataModel in
            return MovieDetailDataModel(movieDetail: movieDetail,
                                        videos: videos,
                                        recommendations: recommendations)
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
            router: .getVideos(mediaID: movie.id ?? 0, mediaType: mediaType),
            type: VideosResponse?.self
        )
    }
    
    private func getRecommendations() -> Observable<RecommendationsResponse?> {
        return HostAPIClient.performApiNetworkCall(
            router: .getRecommendations(mediaID: movie.id ?? 0, mediaType: mediaType),
            type: RecommendationsResponse?.self
        )
    }
}

extension MovieDetailViewModel {
    struct Input {
        var getMovieDetailTrigger: Driver<Void>
    }
    
    struct Output {
        var tempMedia: Driver<Media>
        var movie: Driver<MovieDetailDataModel>
    }
}
