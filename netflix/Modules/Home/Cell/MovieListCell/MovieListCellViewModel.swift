//
//  MovieListCellViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListCellViewModel: ViewModel {
    private let movies: [Media]
    private let mediaType: MediaType
    private let bag = DisposeBag()
    
    init(movies: [Media], mediaType: MediaType) {
        self.movies = movies
        self.mediaType = mediaType 
    }
    
    func transform(input: Input) -> Output {
        input.itemSelected
            .drive(onNext: { [weak self] indexPath in
                guard let self = self, self.movies.indices.contains(indexPath.item) else { return }
                SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: self.movies[indexPath.item], mediaType: self.mediaType))
            })
            .disposed(by: bag)
        return Output(movies: .just(movies))
    }
}

extension MovieListCellViewModel {
    struct Input {
        var itemSelected: Driver<IndexPath>
    }
    
    struct Output {
        var movies: Driver<[Media]>
    }
}
