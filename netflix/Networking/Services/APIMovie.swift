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
    
    //TV Shows
    case getTvShowGenresList
    case getAiringTodayTVShowList(page: Int)
    case getPopularTVShows(page: Int)
    case getTopRatedTvShowsList(page: Int)
    case getTVShowOnTheAir(page: Int)
}

extension APIMovie: TargetType {
    var path: String {
        switch self {
        case .getPopularMovies:
            return APIURL.version + APIURL.movie + APIURL.popular
        case .getTvShowGenresList:
            return APIURL.version + APIURL.genre + APIURL.tv + APIURL.list
        case .getMovieGenresList:
            return APIURL.version + APIURL.genre + APIURL.movie + APIURL.list
        case .getMovieNowPlayingList:
            return APIURL.version + APIURL.movie + APIURL.nowPlaying
        case .getAiringTodayTVShowList:
            return APIURL.version + APIURL.tv + APIURL.airingToday
        case .getPopularTVShows:
            return APIURL.version + APIURL.tv + APIURL.popular
        case .getTopRatedMoviesList:
            return APIURL.version + APIURL.movie + APIURL.topRated
        case .getTopRatedTvShowsList:
            return APIURL.version + APIURL.tv + APIURL.topRated
        case .getUpcomingMoviesList:
            return APIURL.version + APIURL.movie + APIURL.upcoming
        case .getTVShowOnTheAir:
            return APIURL.version + APIURL.tv + APIURL.onTheAir
        }
    }
    
    var method: Moya.Method {
        switch self {
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
