//
//  APIError.swift
//  netflix
//
//  Created by kennyS on 2/26/20.
//

import Foundation

struct APIError: Error, Codable {
    var success: Bool?
    var status_code: Int?
    var status_message: String?
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(status_message ?? ErrorMessage.errorOccur, comment: "")
    }
}
