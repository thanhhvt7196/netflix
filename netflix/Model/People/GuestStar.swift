//
//  GuestStar.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct GuestStar: Codable {
    var id: Int?
    var name: String?
    var creditID: String?
    var character: String?
    var order: Int?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creditID = "credit_id"
        case character
        case order
        case profilePath = "profile_path"
    }
}
