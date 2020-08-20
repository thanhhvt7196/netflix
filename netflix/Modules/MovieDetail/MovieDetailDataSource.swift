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
    case content(titles: [String], item: [Item])
}

enum MovieDetailSectionItem {
    case headerMovie(media: Media, detail: MovieDetailDataModel?)
    case episode(video: Video)
    case recommendMedia(medias: [Media])
}

extension MovieDetailSectionItem: IdentifiableType, Equatable {
    static func == (lhs: MovieDetailSectionItem, rhs: MovieDetailSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        switch self {
        case .headerMovie(_, let detail):
            return "\(detail?.movieDetail?.id ?? 0)"
        case .episode(let video):
            return video.id ?? ""
        case .recommendMedia(let medias):
            return String(medias.compactMap { "\($0.id ?? 0)" }.reduce("", { $0 + $1 }))
        }
    }
    
    
}

extension MovieDetailSectionModel: AnimatableSectionModelType {
    var identity: Int {
        switch self {
        case .headerDetail:
            return 0
        case .content:
            return 1
        }
    }
    
    var items: [MovieDetailSectionItem] {
        switch self {
        case .content(_, let items):
            return items.map { $0 }
        case .headerDetail(let items):
            return items.map { $0 }
        }
    }
    
    init(original: MovieDetailSectionModel, items: [MovieDetailSectionItem]) {
        switch original {
        case .headerDetail:
            self = .headerDetail(item: items)
        case .content(let titles, _):
            self = .content(titles: titles, item: items)
        }
    }
}
