//
//  TVShowCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/7/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowCategoryDataModel: Codable {
    var latestTV: Movie?
    var airingTodayList: [Movie]
    var popularTVShowList: [Movie]
    var topRatedTVShowList: [Movie]
    var tvShowLatestReleaseList: [Movie]
    var mostFavoriteTVShowList: [Movie]
    var koreanTVShowList: [Movie]
    var USTVShowList: [Movie]
}
