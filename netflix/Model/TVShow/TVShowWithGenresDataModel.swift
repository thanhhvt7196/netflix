//
//  TVShowWithGenresDataModel.swift
//  netflix
//
//  Created by thanh tien on 8/8/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct TVShowWithGenresDataModel: Codable {
    var popularTVShowList: [Media]
    var mostFavoriteTVShowList: [Media]
    var koreanTVShowList: [Media]
    var WesternTVShowList: [Media]
    var japaneseTVShowList: [Media]
    var chineseTVShowList: [Media]
}
