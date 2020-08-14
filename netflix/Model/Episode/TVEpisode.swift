//
//  TVEpisode.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVEpisode: Codable {
    var airDate: String?
    var crew: Crew?
    var guestStar: GuestStar?
    var name: String?
    var overview: String?
    var id: Int?
    var productionCode: String?
    var seasonNumber: Int?
    var stillPath: String?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case crew
        case guestStar = "guest_star"
        case name
        case overview
        case id
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
