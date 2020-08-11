//
//  TVShowCategoryDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/7/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowCategoryDataModel: Codable {
    var airingTodayList: [Movie]
    var popularTVShowList: [Movie]
    var topRatedTVShowList: [Movie]
    var mostFavoriteTVShowList: [Movie]
    var koreanTVShowList: [Movie]
    var westernTVShowList: [Movie]
    var chineseTVShowList: [Movie]
}
