//
//  HeaderMovieViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderMovieViewModel: ViewModel {
    var movie: Driver<Movie>
    
    init(movie: Movie) {
        self.movie = .just(movie)
    }
    func transform(input: Input) -> Output {
        return Output(movie: movie)
    }
}

extension HeaderMovieViewModel {
    struct Input {
        
    }
    
    struct Output {
        var movie: Driver<Movie>
    }
}
