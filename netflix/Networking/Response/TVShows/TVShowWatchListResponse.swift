//
//  TVShowWatchListResponse.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowWatchListResponse: Codable {
    var page: Int?
    var results: [Movie]?
    var totalResults: Int?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
