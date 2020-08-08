//
//  TVShowWithGenresDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/8/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowWithGenresDataModel: Codable {
    var popularTVShowList: [Movie]
    var mostFavoriteTVShowList: [Movie]
    var latestReleaseTVShowList: [Movie]
    var koreanTVShowList: [Movie]
    var USTVShowList: [Movie]
    var japaneseTVShowList: [Movie]
}
