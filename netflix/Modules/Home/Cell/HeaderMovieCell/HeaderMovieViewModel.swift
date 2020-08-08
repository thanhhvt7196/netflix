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
    var movie: Movie
    private let bag = DisposeBag()
    
    init(movie: Movie) {
        self.movie = movie
    }
    func transform(input: Input) -> Output {
        input.showMovieDetailTrigger
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: self.movie))
            })
            .disposed(by: bag)
        return Output(movie: .just(movie))
    }
}

extension HeaderMovieViewModel {
    struct Input {
        var showMovieDetailTrigger: Driver<Void>
    }
    
    struct Output {
        var movie: Driver<Movie>
    }
}
