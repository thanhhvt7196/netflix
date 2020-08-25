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
    static let youtubeImageURL = "https://img.youtube.com/vi/%@/hqdefault.jpg"
    static let version3 = "/3"
    static let version4 = "/4"
    static let movie = "/movie"
    static let movies = "/movies"
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
    static let account = "/account"
    static let watchList = "/watchlist"
    static let videos = "/videos"
    static let recommendations = "/recommendations"
    static let similar = "/similar"
    static let credits = "/credits"
    static let trending = "/trending"
}

struct Constants {
    static let APIKey = "85ab510c7fab5ad12a9ca0098ceab35e"
    static let USLanguageCode = "en-US"
    static let defaultLocaleIdentifier = "en_US_POSIX"
    
    static let passwordMinLength = 4
    static let passwordMaxlength = 16
    
    static let privacyURL = "https://help.netflix.com/legal/privacy"
    static let helpURL = "https://help.netflix.com/en"
}

enum CrewRole: String {
    case director = "Director"
    case orchestrator = "Orchestrator"
    case vocal = "Vocals"
    case costumer = "Costumer"
    case dataManagementTechnician = "Data Management Technician"
    case grip = "Grip"
    case translator = "Translator"
    case visualEffectProducer = "Visual Effects Producer"
    case simulationAndEffectsArtist = "Simulation & Effects Artist"
    case compositingArtist = "Compositing Artist"
    case mattePainter = "Matte Painter"
    case animation = "animation"
    case visualEffectProductionAssistant = "Visual Effects Production Assistant"
    case compositingLead = "Compositing Lead"
    case lightningArtist = "Lighting Artist"
    case VFXSupervisor = "VFX Supervisor"
    case visualEffectSupervisor = "Visual Effects Supervisor"
    case VFXArtist = "VFX Artist"
    case VFXEditor = "VFX Editor"
    case CGSupervisor = "CG Supervisor"
    case leadAnimator = "Lead Animator"
    case visualEffectDirector = "Visual Effects Director"
    case compositingSupervisor = "Compositing Supervisor"
    case matchmoveSupervisor = "Matchmove Supervisor"
    case foleyArtist = "Foley Artist"
    case foleyEditor = "Foley Editor"
    case conceptArtist = "Concept Artist"
    case firstAssistantDirector = "First Assistant Director"
    case thirdAssistantDirector = "Third Assistant Director"
    case secondUnitDirector = "Second Unit Director"
    case unitProductionManager = "Unit Production Manager"
    case productionManager = "Production Manager"
    case specialEffectsMakeupArtist = "Special Effects Makeup Artist"
    case coProducer = "Co-Producer"
    case executiveProducerAssistant = "Executive Producer's Assistant"
    case artDirection = "Art Direction"
    case executiveProducer = "Executive Producer"
    case lineProducer = "Line Producer"
    case stuntCoordinator = "Stunt Coordinator"
    case assistantDirector = "Assistant Director"
    case screenPlay = "Screenplay"
    case coExecutiveProducer = "Co-Executive Producer"
    case soundEffectDesigner = "Sound Effects Designer"
    case makeupAndHair = "Makeup & Hair"
    case producer = "Producer"
    case stillPhotographer = "Still Photographer"
    case digitalIntermediate = "Digital Intermediate"
    case originalMusicComposer = "Original Music Composer"
    case themeSongPerformance = "Theme Song Performance"
    case assistantEditor = "Assistant Editor"
    case setDecoration = "Set Decoration"
    case productionDesign = "Production Design"
    case productionSoundMixer = "Production Sound Mixer"
    case dolbyConsultant = "Dolby Consultant"
    case adaptation = "Adaptation"
    case directorOfPhotography = "Director of Photography"
}

enum APIParamKeys {
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
    static let sessionID = "session_id"
    static let mediaType = "media_type"
    static let mediaID = "media_id"
    static let watchList = "watchlist"
}

enum ErrorMessage {
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
