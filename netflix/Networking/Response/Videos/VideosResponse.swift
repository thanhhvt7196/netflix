//
//  VideosResponse.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct VideosResponse: Codable {
    var id: Int?
    var results: [Video]?
}
