//
//  APIError.swift
//  netflix
//
//  Created by kennyS on 2/26/20.
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
