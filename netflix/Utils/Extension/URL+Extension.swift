//
//  URL.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation

extension URL {
    func value(for queryKey: String) -> String? {
        guard let items = URLComponents(string: absoluteString)?.queryItems else { return nil }
        for item in items where item.name == queryKey {
            return item.value
        }
        return nil
    }

    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
