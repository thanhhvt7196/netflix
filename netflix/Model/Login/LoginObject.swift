//
//  LoginObject.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct LoginObject: Codable {
    var username: String?
    var password: String?
    var requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}
