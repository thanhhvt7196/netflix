//
//  Genre.swift
//  netflix
//
//  Created by thanh tien on 7/22/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct Genre: Codable {
    var id: Int?
    var name: String?
}

extension Genre: Equatable {
    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
