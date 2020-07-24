//
//  NowPlayingMovieResponse.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct NowPlayingMovieResponse: Codable {
    var page: Int?
    var results: [Movie]?
    var totalResults: Int?
    var date: NowPlayingMovieDate?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case date
        case totalPages = "total_pages"
    }
}

struct NowPlayingMovieDate: Codable {
    var maximum: String?
    var minimum: String?
}
