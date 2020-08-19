//
//  MovieCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/8/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct MovieCategoryDataModel: Codable {
    var nowPlayingList: [Media]
    var popularMovieList: [Media]
    var topRatedMovieList: [Media]
    var trendingMovieList: [Media]
    var upcomingMovieList: [Media]
    var mostFavoriteMovieList: [Media]
    var topGrossingMovieList: [Media]
}
