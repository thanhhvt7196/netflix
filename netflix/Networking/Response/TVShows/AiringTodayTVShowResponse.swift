//
//  AiringTodayTVShowResponse.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct AiringTodayTVShowResponse: Codable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_resutls"
        case totalPages = "total_pages"
        case results
    }
}
