//
//  MovieWithGenreDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/9/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct MovieWithGenreDataModel: Codable {
    var popularMovieList: [Movie]
    var mostFavoriteMovieList: [Movie]
    var topGrossingMovieList: [Movie]
    var westernMovieList: [Movie]
    var koreanMovieList: [Movie]
    var japaneseMovieList: [Movie]
    var chineseMovieList: [Movie]
}
