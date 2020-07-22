//
//  PopularMoviesResponse.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct PopularMoviesResponse: Codable {
    var page: Int?
    var totalResults: Int?
    var totalPage: Int?
    var results: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPage = "total_page"
        case results
    }
}