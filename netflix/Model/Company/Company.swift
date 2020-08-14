//
//  Company.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct Company: Codable {
    var description: String?
    var headquarters: String?
    var homepage: String?
    var id: Int?
    var logoPath: String?
    var name: String?
    var originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case headquarters
        case homepage
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
