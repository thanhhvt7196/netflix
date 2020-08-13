//
//  MovieHelper.swift
//  netflix
//
//  Created by thanh tien on 8/12/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

class MovieHelper {
    static func getGenresString(movie: Movie) -> String {
        var genreArray = [String]()
        if let ids = movie.genreIds, ids.count > 0 {
            let allMovieGenres = MovieGenreRealmObject.getAllGenres() ?? []
            let allTVShowsGenres = TVGenreRealmObject.getAllGenres() ?? []
            let genreIds = Set((allTVShowsGenres + allMovieGenres).compactMap { $0.id }).intersection(Set(ids))
            let genreNames = (allTVShowsGenres + allMovieGenres).filter { genre -> Bool in
                return genreIds.contains(genre.id ?? 0)
            }
            genreArray = Array(Set(genreNames.compactMap { $0.name }))
        }
        
        if let genres = movie.genres, genres.count > 0 {
            genreArray = genres.compactMap { $0.name }
        }
        return genreArray.joined(separator: " • ")
    }
    
    static func isMyList(movie: Movie) -> Bool {
        return PersistentManager.shared.watchList.compactMap { $0.id }.contains(movie.id ?? -1)
    }
}
