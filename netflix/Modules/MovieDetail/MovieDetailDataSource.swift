//
//  MovieDetailDataSource.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxDataSources

enum MovieDetailSectionModel {
    typealias Item = MovieDetailSectionItem
    
    case headerDetail(item: [Item])
    case pager(titles: [String], item: [Item])
}

enum MovieDetailSectionItem {
    case headerMovie(media: Media, detail: MovieDetailDataModel?)
    case headerTVShow(media: Media)
    case episode(video: Video)
    case recommendMedia(medias: [Media])
}

extension MovieDetailSectionModel: SectionModelType {
    var items: [MovieDetailSectionItem] {
        switch self {
        case .pager(_, let items):
            return items.map { $0 }
        case .headerDetail(let items):
            return items.map { $0 }
        }
    }
    
    init(original: MovieDetailSectionModel, items: [MovieDetailSectionItem]) {
        switch original {
        case .headerDetail:
            self = .headerDetail(item: items)
        case .pager(let titles, _):
            self = .pager(titles: titles, item: items)
        }
    }
}
