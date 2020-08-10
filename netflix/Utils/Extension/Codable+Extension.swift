//
//  Codable+Extension.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

extension Encodable {
    func encodePlist() -> Data? {
        do {
            let encodedValue = try PropertyListEncoder().encode(self)
            return encodedValue
        } catch {
            return nil
        }
    }
}

extension Data {
    func decodeFromPlist<T: Decodable>() -> T? {
        do {
            let decodedValue = try PropertyListDecoder().decode(T.self, from: self)
            return decodedValue
        } catch {
            return nil
        }
    }
}
