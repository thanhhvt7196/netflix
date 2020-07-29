//
//  WKWebview+Extension.swift
//  netflix
//
//  Created by thanh tien on 7/29/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    class func clean() {
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
    }
}
