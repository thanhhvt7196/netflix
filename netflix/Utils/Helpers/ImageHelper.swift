//
//  ImageHelpers.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

enum ImageSize: String {
    case w200 = "/w200"
    case w300 = "/w300"
    case w400 = "/w400"
    case w500 = "/w500"
    case original = "/original"
}

class ImageHelper {
    static let shared = ImageHelper()
    
    func pathToURL(path: String, imageSize: ImageSize) -> URL? {
        return URL(string: APIURL.imageBaseURL + imageSize.rawValue + path)
    }
}
