//
//  TVShowCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/7/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowCategoryDataModel: Codable {
    var airingTodayList: [Media]
    var popularTVShowList: [Media]
    var topRatedTVShowList: [Media]
    var mostFavoriteTVShowList: [Media]
    var trendingTodayTVShowList: [Media]
    var koreanTVShowList: [Media]
    var westernTVShowList: [Media]
    var chineseTVShowList: [Media]
}
