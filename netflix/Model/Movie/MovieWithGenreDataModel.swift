//
//  MovieWithGenreDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/9/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct MovieWithGenreDataModel: Codable {
    var popularMovieList: [Media]
    var mostFavoriteMovieList: [Media]
    var topGrossingMovieList: [Media]
    var westernMovieList: [Media]
    var koreanMovieList: [Media]
    var japaneseMovieList: [Media]
    var chineseMovieList: [Media]
}
