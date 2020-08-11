//
//  HomeCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/7/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct HomeCategoryDataModel: Codable {
    var mostFavoriteMovieList: [Movie]
    var tvShowAiringToday: [Movie]
    var popularMovieList: [Movie]
    var popularTVShowList: [Movie]
    var topRatedMovieList: [Movie]
    var topRatedTVShowList: [Movie]
    var upcomingMovieList: [Movie]
    var tvShowLatestReleaseList: [Movie]
}
