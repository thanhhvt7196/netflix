//
//  Movie+Enum.swift
//  netflix
//
//  Created by thanh tien on 8/1/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

enum MovieSortType: String, CaseIterable {
    case voteAverageDesc = "vote_average.desc"
    case voteAverageAsc = "vote_average.asc"
    case firstAirDateDesc = "first_air_date.desc"
    case firstAirDateAsc = "first_air_date.asc"
    case popularityDesc = "popularity.desc"
    case popularityAsc = "popularity.asc"
}


