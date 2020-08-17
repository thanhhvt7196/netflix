//
//  MovieDetailDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/15/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct MovieDetailDataModel: Codable {
    var movieDetail: MovieDetailModel?
    var videos: [Video]
    var recommendations: [Media]
    var similarMedia: [Media]
    var cast: [Cast]
    var crew: [Crew]
}
