//
//  APIError.swift
//  netflix
//
//  Created by kennyS on 2/26/20.
//

import Foundation

struct APIError: Error, Codable {
    let status_code: Int?
    let status_message: String
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(status_message, comment: "")
    }
}
