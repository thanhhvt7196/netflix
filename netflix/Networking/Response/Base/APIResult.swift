//
//  APIResult.swift
//  EnjapanMoya
//
//  Created by HieuTQ on 2/26/20.
//  Copyright © 2020 HieuTQ. All rights reserved.
//

import Foundation

enum APIResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}
