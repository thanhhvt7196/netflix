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
    var koreanTVShowList: [Movie]
    var WesternTVShowList: [Movie]
    var japaneseTVShowList: [Movie]
    var chineseTVShowList: [Movie]
}
