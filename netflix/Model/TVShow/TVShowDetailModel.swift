//
//  TVShowDetailModel.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowDetailModel: Codable {
    var backdropPath: String?
    var createdBy: People?
    var episodeRunTime: [Int]?
    var firstAirDate: String?
    var genres: [Genre]?
    var homepage: String?
    var id: Int?
    var inProduction: Bool?
    var languages: [String]?
    var lastAirDate: String?
    var lastEpisodeToAir: TVEpisode?
    var name: String?
    var nextEpisodeToAir: TVEpisode?
    var networks: [Network]?
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var originCountry: [String]?
    var originalLanguage: String?
    var originalName: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var productionCompanies: [Company]?
    var seasons: [TVSeason]?
    var status: String?
    var type: String?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case seasons
        case status
        case type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
