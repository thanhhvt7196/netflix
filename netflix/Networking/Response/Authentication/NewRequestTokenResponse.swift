//
//  NewRequestTokenResponse.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct NewRequestTokenResponse: Codable {
    var success: Bool?
    var expiresAt: String?
    var requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
