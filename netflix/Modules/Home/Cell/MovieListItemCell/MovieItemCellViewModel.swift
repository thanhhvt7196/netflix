//
//  MovieItemCellViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieItemCellViewModel: ViewModel {
    private let movie: Driver<Movie>
    
    init(movie: Movie) {
        self.movie = .just(movie)
    }
    func transform(input: Input) -> Output {
        return Output(movie: movie)
    }
}

extension MovieItemCellViewModel {
    struct Input {
        
    }
    
    struct Output {
        var movie: Driver<Movie>
    }
}
