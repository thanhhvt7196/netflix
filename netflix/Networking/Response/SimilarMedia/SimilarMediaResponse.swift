//
//  SimilarMediaResponse.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct SimilarMediaResponse: Codable {
    var page: Int?
    var totalResults: Int?
    var totalPage: Int?
    var results: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPage = "total_page"
        case results
    }
}
