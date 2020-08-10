//
//  BaseSuccessResult.swift
//  netflix
//
//  Created by thanh tien on 8/10/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation

struct BaseSuccessResult: Error, Codable {
    var success: Bool?
    var status_code: Int?
    var status_message: String?
}
