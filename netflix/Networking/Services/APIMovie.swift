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
    case getPopularMovies
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
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
}
