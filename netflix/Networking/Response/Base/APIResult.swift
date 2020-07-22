//
//  APIResult.swift
//  netflix
//
//  Created by kennyS on 2/26/20.
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
