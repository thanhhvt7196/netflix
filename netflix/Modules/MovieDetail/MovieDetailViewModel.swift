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
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func transform(input: Input) -> Output {
        return Output(movie: .just(movie))
    }
}

extension MovieDetailViewModel {
    struct Input {
        var getMovieDetailTrigger: Driver<Void>
    }
    
    struct Output {
        var movie: Driver<Movie>
    }
}
