//
//  APIProvider.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Moya

enum APIMovie {
    //Movie
    case getMovieGenresList
    case getMovieNowPlayingList(page: Int)
    case getPopularMovies(page: Int)
    case getTopRatedMoviesList(page: Int)
    case getUpcomingMoviesList(page: Int)
    case getLatestMovie
    case discoverMovie(sortBy: MovieSortType?, page: Int, genre: Int?, includeVideo: Bool, originalLanguage: LanguageCodes?)
    
    
    //TV Shows
    case getTvShowGenresList
    case getAiringTodayTVShowList(page: Int)
    case getPopularTVShows(page: Int)
    case getTopRatedTvShowsList(page: Int)
    case getTVShowOnTheAir(page: Int)
    case discoverTV(sortBy: TVShowSortType?, page: Int, genre: Int?, originalLanguage: LanguageCodes?)
    case getLatestTV
    
    //authentication
    case createRequestToken
    case verifyRequestToken(username: String, password: String, token: String)
    case createSession(token: String)
    
    //user info
    case getAccountDetail(sessionID: String)
    case addToWatchlist(accountID: Int, mediaType: MediaType, mediaID: Int, watchList: Bool)
    case getMovieWatchList(accountID: Int)
    case getTVShowWatchList(accountID: Int)
}

extension APIMovie: TargetType {
    var path: String {
        switch self {
        case .getPopularMovies:
            return APIURL.version3 + APIURL.movie + APIURL.popular
        case .getTvShowGenresList:
            return APIURL.version3 + APIURL.genre + APIURL.tv + APIURL.list
        case .getMovieGenresList:
            return APIURL.version3 + APIURL.genre + APIURL.movie + APIURL.list
        case .getMovieNowPlayingList:
            return APIURL.version3 + APIURL.movie + APIURL.nowPlaying
        case .getAiringTodayTVShowList:
            return APIURL.version3 + APIURL.tv + APIURL.airingToday
        case .getPopularTVShows:
            return APIURL.version3 + APIURL.tv + APIURL.popular
        case .getTopRatedMoviesList:
            return APIURL.version3 + APIURL.movie + APIURL.topRated
        case .getTopRatedTvShowsList:
            return APIURL.version3 + APIURL.tv + APIURL.topRated
        case .getUpcomingMoviesList:
            return APIURL.version3 + APIURL.movie + APIURL.upcoming
        case .getTVShowOnTheAir:
            return APIURL.version3 + APIURL.tv + APIURL.onTheAir
        case .createRequestToken:
            return APIURL.version3 + APIURL.authentication + APIURL.token + APIURL.new
        case .verifyRequestToken:
            return APIURL.version3 + APIURL.authentication + APIURL.token + APIURL.validateWithLogin
        case .createSession:
            return APIURL.version3 + APIURL.authentication + APIURL.session + APIURL.new
        case .discoverTV:
            return APIURL.version3 + APIURL.discover + APIURL.tv
        case .getLatestTV:
            return APIURL.version3 + APIURL.tv + APIURL.latest
        case .getLatestMovie:
            return APIURL.version3 + APIURL.movie + APIURL.latest
        case .discoverMovie:
            return APIURL.version3 + APIURL.discover + APIURL.movie
        case .getAccountDetail:
            return APIURL.version3 + APIURL.account
        case .addToWatchlist(let accountID, _, _, _):
            return APIURL.version3 + APIURL.account + "/\(accountID)" + APIURL.watchList
        case .getMovieWatchList(let accountID):
            return APIURL.version3 + APIURL.account + "/\(accountID)" + APIURL.watchList + APIURL.movies
        case .getTVShowWatchList(let accountID):
            return APIURL.version3 + APIURL.account + "/\(accountID)" + APIURL.watchList + APIURL.tv
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .verifyRequestToken:
            return .post
        case .createSession:
            return .post
        case .addToWatchlist:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPopularMovies:
            return JSONHelper.dataFromFile(path: "Networking/SampleData/PopularMoviesSample") ?? Data()
        default:
            return Data()
        }
    }
    
    var task: Task {
        var parameters: [String: Any] = [APIParamKeys.APIKey: Constants.APIKey]
        var encoding: ParameterEncoding = URLEncoding.default
        var urlParameter: [String: Any] = [:]
        switch self {
        case .getPopularMovies(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getPopularTVShows(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getMovieNowPlayingList(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getAiringTodayTVShowList(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getUpcomingMoviesList(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getTVShowOnTheAir(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .verifyRequestToken(let username, let password, let token):
            encoding = JSONEncoding.default
            urlParameter = [APIParamKeys.APIKey: Constants.APIKey]
            parameters = [APIParamKeys.username: username, APIParamKeys.password: password, APIParamKeys.requestToken: token]
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: encoding, urlParameters: urlParameter)
        case .createSession(let token):
            encoding = JSONEncoding.default
            parameters = [APIParamKeys.requestToken: token]
            urlParameter = [APIParamKeys.APIKey: Constants.APIKey]
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: encoding, urlParameters: urlParameter)
        case .discoverTV(let sortBy, let page, let genre, let originalLanguage):
            encoding = URLEncoding.default
            if let sortType = sortBy?.rawValue {
                parameters[APIParamKeys.sortBy] = sortType
            }
            if let genre = genre {
                parameters[APIParamKeys.withGenres] = genre
            }
            if let language = originalLanguage?.rawValue.lowercased() {
                parameters[APIParamKeys.withOriginalLanguage] = language
            }
            parameters[APIParamKeys.page] = page
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .discoverMovie(let sortBy, let page, let genre, let video, let originalLanguage):
            encoding = URLEncoding.default
            if let sortType = sortBy?.rawValue {
                parameters[APIParamKeys.sortBy] = sortType
            }
            if let genre = genre {
                parameters[APIParamKeys.withGenres] = genre
            }
            if let language = originalLanguage?.rawValue.lowercased() {
                parameters[APIParamKeys.withOriginalLanguage] = language
            }
            parameters[APIParamKeys.includeVideo] = video
            parameters[APIParamKeys.page] = page
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getAccountDetail(let sessionID):
            encoding = URLEncoding.default
            parameters = [APIParamKeys.APIKey: Constants.APIKey,
                          APIParamKeys.sessionID: sessionID]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .addToWatchlist(_, let mediaType, let mediaID, let watchList):
            encoding = JSONEncoding.default
            urlParameter = [APIParamKeys.APIKey: Constants.APIKey,
                            APIParamKeys.sessionID: PersistentManager.shared.sessionID]
            parameters = [APIParamKeys.mediaID: mediaID,
                          APIParamKeys.mediaType: mediaType.rawValue,
                          APIParamKeys.watchList: watchList]
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: encoding, urlParameters: urlParameter)
        case .getMovieWatchList:
            encoding = URLEncoding.default
            parameters = [APIParamKeys.APIKey: Constants.APIKey,
                          APIParamKeys.sessionID: PersistentManager.shared.sessionID]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getTVShowWatchList:
            encoding = URLEncoding.default
            parameters = [APIParamKeys.APIKey: Constants.APIKey,
                          APIParamKeys.sessionID: PersistentManager.shared.sessionID]
            return .requestParameters(parameters: parameters, encoding: encoding)
        default:
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var headers: [String : String]? {
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
        ]
    }
    
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
}
