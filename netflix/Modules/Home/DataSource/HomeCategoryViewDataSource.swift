//
//  HomeCategoryViewDataSource.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxDataSources

enum HomeCategoryViewSectionModel {
    typealias Item = HomeCategoryViewSectionItem
    case headerMovie(title: String?, items: [Item])
    case nowPlayingMovie(title: String, items: [Item])
    case tvShowAiringToday(title: String, items: [Item])
    case popularMovies(title: String, items: [Item])
    case popularTVShows(title: String, items: [Item])
    case topRatedMovies(title: String, items: [Item])
    case topRatedTVShows(title: String, items: [Item])
    case upcomingMovie(title: String, items: [Item])
    case tvShowOnTheAir(title: String, items: [Item])
    case mostFavoriteTVShow(title: String, items: [Item])
    case USTVShow(title: String, items: [Item])
    case koreanTVShow(title: String, items: [Item])
    case japaneseTVShow(title: String, items: [Item])
}

enum HomeCategoryViewSectionItem {
    case headerMovie(movie: Movie)
    case previewList(movies: [Movie])
    case moviesListItem(movies: [Movie])
}

extension HomeCategoryViewSectionModel: SectionModelType {
    var items: [HomeCategoryViewSectionItem] {
        switch self {
        case .headerMovie(_, let items):
            return items.map { $0 }
        case .nowPlayingMovie(_, let items):
            return items.map { $0 }
        case .tvShowAiringToday(_, let items):
            return items.map { $0 }
        case .popularMovies(_, let items):
            return items.map { $0 }
        case .popularTVShows(_, let items):
            return items.map { $0 }
        case .topRatedMovies(_, let items):
            return items.map { $0 }
        case .upcomingMovie(_, let items):
            return items.map { $0 }
        case .tvShowOnTheAir(_, let items):
            return items.map { $0 }
        case .topRatedTVShows(_, let items):
            return items.map { $0 }
        case .mostFavoriteTVShow(_, let items):
            return items.map { $0 }
        case .USTVShow(_, let items):
            return items.map { $0 }
        case .koreanTVShow(_, let items):
            return items.map { $0 }
        case .japaneseTVShow(_, let items):
            return items.map { $0 }
        }
    }
    
    var title: String? {
        switch self {
        case .headerMovie(let title, _):
            return title
        case .nowPlayingMovie(let title, _):
            return title
        case .popularMovies(let title, _):
            return title
        case .popularTVShows(let title, _):
            return title
        case .topRatedMovies(let title, _):
            return title
        case .topRatedTVShows(let title, _):
            return title
        case .tvShowOnTheAir(let title, _):
            return title
        case .tvShowAiringToday(let title, _):
            return title
        case .upcomingMovie(let title, _):
            return title
        case .mostFavoriteTVShow(let title, _):
            return title
        case .USTVShow(let title, _):
            return title
        case .koreanTVShow(let title, _):
            return title
        case .japaneseTVShow(let title, _):
            return title
        }
    }
    
    init(original: HomeCategoryViewSectionModel, items: [HomeCategoryViewSectionItem]) {
        switch original {
        case let .headerMovie(title: title, items: _):
            self = .headerMovie(title: title, items: items)
        case let .nowPlayingMovie(title: title, items: _):
            self = .nowPlayingMovie(title: title, items: items)
        case let .tvShowAiringToday(title: title, items: _):
            self = .tvShowAiringToday(title: title, items: items)
        case let .popularMovies(title: title, items: _):
            self = .popularMovies(title: title, items: items)
        case let .popularTVShows(title: title, items: _):
            self = .popularTVShows(title: title, items: items)
        case let .topRatedMovies(title: title, items: _):
            self = .topRatedMovies(title: title, items: items)
        case let .topRatedTVShows(title: title, items: _):
            self = .topRatedTVShows(title: title, items: items)
        case let .upcomingMovie(title: title, items: _):
            self = .upcomingMovie(title: title, items: items)
        case let .tvShowOnTheAir(title: title, items: _):
            self = .tvShowOnTheAir(title: title, items: items)
        case let .mostFavoriteTVShow(title: title, items: _):
            self = .mostFavoriteTVShow(title: title, items: items)
        case let .USTVShow(title: title, items: _):
            self = .USTVShow(title: title, items: items)
        case let .koreanTVShow(title: title, items: _):
            self = .koreanTVShow(title: title, items: items)
        case let .japaneseTVShow(title: title, items: _):
            self = .japaneseTVShow(title: title, items: items)
        }
    }
}
