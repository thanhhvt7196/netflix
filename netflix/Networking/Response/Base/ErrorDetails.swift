//
//  ErrorDetails.swift
//  dev
//
//  Created by kennyS on 21/7/20.
//

import Foundation

struct ErrorDetails: Codable {
    let status: IntStringValue?
    let displayMessage: String?
    let message: String?
    let msg: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case displayMessage = "display_message"
        case message = "message"
        case msg
    }

    init(status: IntStringValue? = nil, message: String? = nil, displayText: String, msg: String? = nil) {
        self.status = status
        self.message = message
        self.displayMessage = displayText
        self.msg = msg
    }
}

extension Error {
    func toErrorDetails() -> ErrorDetails {
        return ErrorDetails(displayText: localizedDescription)
    }
}
