//
//  CreditsResponse.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct CreditsResponse: Codable {
    var id: Int?
    var cast: [Cast]?
    var crew: [Crew]?
}
