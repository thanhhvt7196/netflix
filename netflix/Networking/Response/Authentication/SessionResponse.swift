//
//  SessionResponse.swift
//  netflix
//
//  Created by thanh tien on 7/28/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    var success: Bool?
    var sessionID: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
