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
    case latestReleaseTVShow(title: String, items: [Item])
    case latestReleaseMovie(title: String, items: [Item])
    case mostFavoriteTVShow(title: String, items: [Item])
    case WesternTVShow(title: String, items: [Item])
    case koreanTVShow(title: String, items: [Item])
    case japaneseTVShow(title: String, items: [Item])
    case mostFavoriteMovie(title: String, items: [Item])
    case adultMovie(title: String, items: [Item])
    case topGrossingMovie(title: String, items: [Item])
    case chineseTVShow(title: String, items: [Item])
    case chineseMovie(title: String, items: [Item])
    case trendingToday(title: String, items: [Item])
}

enum HomeCategoryViewSectionItem {
    case headerMovie(movie: Media)
    case previewList(movies: [Media], mediaType: MediaType)
    case moviesListItem(movies: [Media], mediaType: MediaType)
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
        case .latestReleaseTVShow(_, let items):
            return items.map { $0 }
        case .topRatedTVShows(_, let items):
            return items.map { $0 }
        case .mostFavoriteTVShow(_, let items):
            return items.map { $0 }
        case .WesternTVShow(_, let items):
            return items.map { $0 }
        case .koreanTVShow(_, let items):
            return items.map { $0 }
        case .japaneseTVShow(_, let items):
            return items.map { $0 }
        case .adultMovie(_, let items):
            return items.map { $0 }
        case .mostFavoriteMovie(_, let items):
            return items.map { $0 }
        case .topGrossingMovie(_, let items):
            return items.map { $0 }
        case .latestReleaseMovie(_, let items):
            return items.map { $0 }
        case .chineseTVShow(_, let items):
            return items.map { $0 }
        case .chineseMovie(_, let items):
            return items.map { $0 }
        case .trendingToday(_, let items):
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
        case .latestReleaseTVShow(let title, _):
            return title
        case .tvShowAiringToday(let title, _):
            return title
        case .upcomingMovie(let title, _):
            return title
        case .mostFavoriteTVShow(let title, _):
            return title
        case .WesternTVShow(let title, _):
            return title
        case .koreanTVShow(let title, _):
            return title
        case .japaneseTVShow(let title, _):
            return title
        case .adultMovie(let title, _):
            return title
        case .mostFavoriteMovie(let title, _):
            return title
        case .topGrossingMovie(let title, _):
            return title
        case .latestReleaseMovie(let title, _):
            return title
        case .chineseMovie(let title, _):
            return title
        case .chineseTVShow(let title, _):
            return title
        case .trendingToday(let title, _):
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
        case let .latestReleaseTVShow(title: title, items: _):
            self = .latestReleaseTVShow(title: title, items: items)
        case let .mostFavoriteTVShow(title: title, items: _):
            self = .mostFavoriteTVShow(title: title, items: items)
        case let .WesternTVShow(title: title, items: _):
            self = .WesternTVShow(title: title, items: items)
        case let .koreanTVShow(title: title, items: _):
            self = .koreanTVShow(title: title, items: items)
        case let .japaneseTVShow(title: title, items: _):
            self = .japaneseTVShow(title: title, items: items)
        case let .adultMovie(title: title, items: _):
            self = .adultMovie(title: title, items: items)
        case let .mostFavoriteMovie(title: title, items: _):
            self = .mostFavoriteMovie(title: title, items: items)
        case let .topGrossingMovie(title: title, items: _):
            self = .topGrossingMovie(title: title, items: items)
        case let .latestReleaseMovie(title: title, items: _):
            self = .latestReleaseMovie(title: title, items: items)
        case let .chineseMovie(title: title, items: _):
            self = .chineseMovie(title: title, items: items)
        case let .chineseTVShow(title: title, items: _):
            self = .chineseTVShow(title: title, items: items)
        case let .trendingToday(title: title, items: _):
            self = .trendingToday(title: title, items: items)
        }
    }
}
