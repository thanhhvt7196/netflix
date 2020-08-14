//
//  Network.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct Network: Codable {
    var headquarters: String?
    var homepage: String?
    var id: Int?
    var name: String?
    var originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case headquarters
        case homepage
        case id
        case name
        case originCountry = "origin_country"
    }
}
