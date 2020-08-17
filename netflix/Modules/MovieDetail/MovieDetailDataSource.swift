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
    case pager(item: [Item])
    case content(item: [Item])
}

enum MovieDetailSectionItem {
    case headerMovie(media: Media, detail: MovieDetailDataModel?)
    case headerTVShow
    case pager
    case episode
    case recommendMedia
}

extension MovieDetailSectionModel: SectionModelType {
    var items: [MovieDetailSectionItem] {
        switch self {
        case .pager(let items):
            return items.map { $0 }
        case .headerDetail(let items):
            return items.map { $0 }
        case .content(let items):
            return items.map { $0 }
        }
    }
    
    init(original: MovieDetailSectionModel, items: [MovieDetailSectionItem]) {
        switch original {
        case .content:
            self = .content(item: items)
        case .headerDetail:
            self = .headerDetail(item: items)
        case .pager:
            self = .pager(item: items)
        }
    }
}
