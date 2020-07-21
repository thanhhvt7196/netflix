//
//  BaseResponse.swift
//  geo
//
//  Created by thanh tien on 9/26/19.
//

import Foundation

struct BaseResponseDetail: Codable {
    var status: Int?
    var text: String?
    var message: String?
}
