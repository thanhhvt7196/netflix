//
//  CaseIterable+Extension.swift
//  netflix
//
//  Created by thanh tien on 8/20/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
