//
//  ErrorResponse.swift
//  netflix
//
//  Created by kennyS on 8/7/19.
//

import Foundation

public enum ErrorResponse: Swift.Error, CustomStringConvertible {

    case error(Int, String)

    public var description: String {
        switch self {
        case .error(_, let message):
            return message
        }
    }

    public var code: Int {
        switch self {
        case .error(let code, _):
            return code
        }
    }
}
