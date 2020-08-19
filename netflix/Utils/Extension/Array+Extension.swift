//
//  Array+Extension.swift
//  netflix
//
//  Created by thanh tien on 8/20/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array {
    mutating func remove(at indexes: [Int]) -> Array {
        var lastIndex: Int?
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
        return self
    }
    
    func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key: Element] {
        var dictionary = [Key: Element]()
        for element in self {
            dictionary[selectKey(element)] = element
        }
        return dictionary
    }
    
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
