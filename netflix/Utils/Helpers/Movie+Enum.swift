//
//  Movie+Enum.swift
//  netflix
//
//  Created by thanh tien on 8/1/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

enum TVShowSortType: String, CaseIterable {
    case voteAverageDesc = "vote_average.desc"
    case voteAverageAsc = "vote_average.asc"
    case firstAirDateDesc = "first_air_date.desc"
    case firstAirDateAsc = "first_air_date.asc"
    case popularityDesc = "popularity.desc"
    case popularityAsc = "popularity.asc"
}

enum MovieSortType: String, CaseIterable {
    case voteAverageDesc = "vote_average.desc"
    case voteAverageAsc = "vote_average.asc"
    case popularityDesc = "popularity.desc"
    case popularityAsc = "popularity.asc"
    case releaseDateDesc = "release_date.desc"
    case releaseDateAsc = "release_date.asc"
    case revenueDesc = "revenue.desc"
    case revenueAsc = "revenue.asc"
}

enum MediaType: String, CaseIterable {
    case tv
    case movie
}

enum MovieStatus: String, CaseIterable {
    case rumored = "Rumored"
    case planned = "Planned"
    case inProduction = "In Production"
    case postProduction = "Post Production"
    case released = "Released"
    case canceled = "Canceled"
}

enum TimePeriod: String {
    case day
    case week
}
