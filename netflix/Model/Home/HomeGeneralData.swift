//
//  HomeGeneralData.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct HomeGeneralData: Codable {
    var tvGenres: [Genre]?
    var movieGenres: [Genre]?
    var tvShowWatchList: [Media]?
    var movieWatchList: [Media]?
    var tvShowFavoriteList: [Media]?
    var movieFavoriteList: [Media]?
}
