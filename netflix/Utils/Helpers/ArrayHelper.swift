//
//  ArrayHelper.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

class ArrayHelper {
    static func combine<T>(arrays:[[T]]) -> [T] {
        let maxCount = arrays.reduce(0) { max($0, $1.count) }
        var result = [T]()

        for i in 0..<maxCount {
            for array in arrays {
                if i < array.count {
                    result.append(array[i])
                }
            }
        }
        return result
    }
}
