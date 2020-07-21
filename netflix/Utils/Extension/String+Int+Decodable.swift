//
//  String+Int+Decodable.swift
//  myNews
//
//  Created by kennyS on 6/16/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation

enum IntStringValue: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        throw DecodingError.typeMismatch(IntStringValue.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for is_enabled value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        }
    }
}

extension IntStringValue {
    func checkValue(comparedValue: String) -> Bool {
        return stringValue == comparedValue
    }
    
    var stringValue: String {
        switch self {
        case .int(let x):
            return "\(x)"
        case .string(let x):
            return x
        }
    }
    
    var intValue: Int? {
        switch self {
        case .int(let x):
            return x
        case .string(let x):
            return Int(x)
        }
    }
}

extension IntStringValue: Equatable {
    static func == (lhs: IntStringValue, rhs: IntStringValue) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}
