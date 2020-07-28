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
    
    //authentication
    case createRequestToken
    case verifyRequestToken(username: String, password: String, token: String)
    case createSession(token: String)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .verifyRequestToken:
            return .post
        case .createSession:
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
