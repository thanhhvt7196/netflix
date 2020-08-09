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
    static let imageBaseURL = "https://image.tmdb.org/t/p"
    static let version3 = "/3"
    static let version4 = "/4"
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
    static let authentication = "/authentication"
    static let token = "/token"
    static let new = "/new"
    static let validateWithLogin = "/validate_with_login"
    static let session = "/session"
    static let discover = "/discover"
    static let latest = "/latest"
}

struct Constants {
    static let APIKey = "1e0dcaa7e93980fb84e1d2430d01b887"
    static let USLanguageCode = "en-US"
    
    static let passwordMinLength = 4
    static let passwordMaxlength = 16
    
    static let privacyURL = "https://help.netflix.com/legal/privacy"
    static let helpURL = "https://help.netflix.com/en"
}

struct APIParamKeys {
    static let APIKey = "api_key"
    static let page = "page"
    static let language = "language"
    static let username = "username"
    static let password = "password"
    static let requestToken = "request_token"
    static let sortBy = "sort_by"
    static let withGenres = "with_genres"
    static let withOriginalLanguage = "with_original_language"
    static let includeVideo = "include_video"
}

struct ErrorMessage {
    static let notFound = "Not found"
    static let authenticalError = "Authentical error"
    static let badRequest = "Bad request"
    static let serverError = "Server error"
    static let errorOccur = "An error occurs"
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
