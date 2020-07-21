//
//  Result.swift
//  dev
//
//  Created by kennyS on 21/7/20.
//

import Foundation

//TODO: Need to replace this Result with Swift 5's default result enum
enum Result<T, E> {
    case success(T)
    case failure(E)
}
