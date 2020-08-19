//
//  ChooseCategoryViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChooseCategoryViewModel: ViewModel {
    func transform(input: Input) -> Output {
        var genres: [Genre]
        switch PersistentManager.shared.categoryType {
        case .tvShow:
            genres = TVGenreRealmObject.getAllGenres() ?? []
        case .movies:
            genres = MovieGenreRealmObject.getAllGenres() ?? []
        default:
            genres = []
        }
        
        genres.insert(PersistentManager.shared.allGenre, at: 0)
        let selectedGenre = input.selectedItem.flatMapLatest { indexPath -> Driver<Genre> in
            guard genres.indices.contains(indexPath.row) else {
                return .empty()
            }
            return .just(genres[indexPath.row])
        }
        
        return Output(genreList: Driver.just(genres),
                      selectedGenre: selectedGenre)
    }
}

extension ChooseCategoryViewModel {
    struct Input {
        var selectedItem: Driver<IndexPath>
    }
    
    struct Output {
        var genreList: Driver<[Genre]>
        var selectedGenre: Driver<Genre>
    }
}
