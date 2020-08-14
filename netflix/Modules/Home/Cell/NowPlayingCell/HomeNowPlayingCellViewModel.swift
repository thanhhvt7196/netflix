//
//  HomeNowPlayingCellViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/30/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeNowPlayingCellViewModel: ViewModel {
    private let movies: Driver<[Media]>
    private let mediaType: MediaType
    
    init(movies: [Media], mediaType: MediaType) {
        self.movies = .just(movies)
        self.mediaType = mediaType
    }
    
    func transform(input: Input) -> Output {
        return Output(movies: movies)
    }
}

extension HomeNowPlayingCellViewModel {
    struct Input {
        var itemSelected: Driver<IndexPath>
    }
    
    struct Output {
        var movies: Driver<[Media]>
    }
}
