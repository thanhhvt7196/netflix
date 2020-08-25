//
//  TVShowFavoriteListResponse.swift
//  netflix
//
//  Created by thanh tien on 8/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowFavoriteListResponse: Codable {
    var page: Int?
    var results: [Media]?
    var totalResults: Int?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
