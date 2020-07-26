//
//  URLds.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct APIURL {
    static let baseURL = "https://api.themoviedb.org"
    static let imageBaseURL = "https://image.tmdb.org/t/p/original"
    static let version = "/3"
    static let movie = "/movie"
    static let popular = "/popular"
    static let genre = "/genre"
    static let list = "/list"
    static let tv = "/tv"
    static let nowPlaying = "/now_playing"
    static let airingToday = "/airing_today"
    static let topRated = "/top_rated"
    static let upcoming = "/upcoming"
    static let onTheAir = "/on_the_air"
}

struct Constants {
    static let APIKey = "1e0dcaa7e93980fb84e1d2430d01b887"
    static let USLanguageCode = "en-US"
}

struct APIParamKeys {
    static let APIKey = "api_key"
    static let page = "page"
    static let language = "language"
}

struct ErrorMessage {
    static let notFound = "Not found"
    static let authenticalError = "Authentical error"
    static let badRequest = "Bad request"
    static let serverError = "Server error"
    static let errorOccur = "An error occur"
}

struct APIConstants {
    static let DEFAULT_TIMEOUT_INTERVAL: TimeInterval = 60.0
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case ifModifiedSince = "If-Modified-Since"
    case userAgent = "User-Agent"
    case cookie = "Cookie"
    case deviceGuid = "X-DEVICE-GUID"
    case notificationId = "X-Push-Notify"
    case urlScheme = "X-Url-Scheme"
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case password = "X- -Password"
    case html = "text/html"
}
