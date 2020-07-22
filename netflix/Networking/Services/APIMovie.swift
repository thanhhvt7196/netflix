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
    case getPopularMovies(page: Int)
}

extension APIMovie: TargetType {
    var path: String {
        switch self {
        case .getPopularMovies:
            return APIURL.version + APIURL.movie + APIURL.popular
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMovies:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPopularMovies:
            return JSONHelper.dataFromFile(path: "Networking/SampleData/PopularMoviesSample") ?? Data()
        }
    }
    
    var task: Task {
        var parameters = [String: Any]()
        var encoding: ParameterEncoding = JSONEncoding.default
        switch self {
        case .getPopularMovies(let page):
            parameters = [APIParamKeys.APIKey: Constants.APIKey, APIParamKeys.page: page, APIParamKeys.language: Constants.USLanguageCode]
            encoding = URLEncoding.default
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
