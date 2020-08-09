//
//  MovieCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/8/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct MovieCategoryDataModel: Codable {
    var nowPlayingList: [Movie]
    var popularMovieList: [Movie]
    var topRatedMovieList: [Movie]
    var upcomingMovieList: [Movie]
    var mostFavoriteMovieList: [Movie]
    var topGrossingMovieList: [Movie]
}
