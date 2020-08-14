//
//  People.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct People: Codable {
    var birthDay: String?
    var knownForDepartment: String?
    var deathDay: String?
    var id: Int?
    var name: String?
    var alsoKnownAs: [String]?
    var gender: Int?
    var biography: String?
    var popularity: Double?
    var placeOfBirth: String?
    var profilePath: String?
    var adult: Bool?
    var imdbID: String?
    var homepage: String?
    
    enum CodingKeys: String, CodingKey {
        case birthDay = "birthday"
        case knownForDepartment = "known_for_department"
        case deathDay = "deathday"
        case id
        case name
        case alsoKnownAs = "also_known_as"
        case gender
        case biography
        case popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }
}
