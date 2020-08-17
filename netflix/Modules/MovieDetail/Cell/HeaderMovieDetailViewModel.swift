//
//  HeaderMovieDetailViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderMovieDetailViewModel: ViewModel {
    private let media: Media
    private var movieDetailData: MovieDetailDataModel?
    
    init(media: Media, detail: MovieDetailDataModel?) {
        self.media = media
        self.movieDetailData = detail
    }
    
    func transform(input: Input) -> Output {
        return Output(media: .just(media),
                      movieDetail: .just(movieDetailData))
    }
}

extension HeaderMovieDetailViewModel {
    struct Input {
        
    }
    
    struct Output {
        var media: Driver<Media>
        var movieDetail: Driver<MovieDetailDataModel?>
    }
}
