//
//  Crew.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct Crew: Codable {
    var id: Int?
    var creditID: String?
    var name: String?
    var department: String?
    var job: String?
    var profilePath: String?
    var gender: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creditID = "credit_id"
        case department
        case job
        case profilePath = "profile_path"
        case gender 
    }
}
