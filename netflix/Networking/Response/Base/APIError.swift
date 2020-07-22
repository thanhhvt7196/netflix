//
//  APIError.swift
//  EnjapanMoya
//
//  Created by HieuTQ on 2/26/20.
//  Copyright © 2020 HieuTQ. All rights reserved.
//

import Foundation

struct APIError: Error, Codable {
    let status: Int?
    let message: String
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
