//
//  ImageHelpers.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

class ImageHelper {
    static let shared = ImageHelper()
    
    func pathToURL(path: String) -> URL? {
        return URL(string: APIURL.imageBaseURL + path)
    }
}
