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
    private let medias: [Media]
    private let mediaType: MediaType
    let rowIndexPath: IndexPath
    
    init(medias: [Media], mediaType: MediaType, indexPath: IndexPath) {
        self.medias = medias.filter { !$0.posterPath.isNilOrEmpty }
        self.mediaType = mediaType
        self.rowIndexPath = indexPath
    }
    
    func transform(input: Input) -> Output {
        let movieSelected = input.itemSelected
            .flatMapLatest { [unowned self] indexPath -> Driver<Media> in
                guard self.medias.indices.contains(indexPath.item) else {
                    return .empty()
                }
                return .just(self.medias[indexPath.item])
            }
            .asDriver()
        
        return Output(medias: .just(medias),
                      mediaSelected: movieSelected,
                      mediaType: .just(mediaType))
    }
}

extension MovieListCellViewModel {
    struct Input {
        var itemSelected: Driver<IndexPath>
    }
    
    struct Output {
        var medias: Driver<[Media]>
        var mediaSelected: Driver<Media>
        var mediaType: Driver<MediaType>
    }
}
