//
//  HomeCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/7/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct HomeCategoryDataModel: Codable {
    var mostFavoriteMovieList: [Media]
    var tvShowAiringToday: [Media]
    var popularMovieList: [Media]
    var popularTVShowList: [Media]
    var topRatedMovieList: [Media]
    var topRatedTVShowList: [Media]
    var upcomingMovieList: [Media]
    var tvShowLatestReleaseList: [Media]
}
