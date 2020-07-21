//
//  NetworkManager.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya

class NetworkManager {
    static let eventMonitor = ClosureEventMonitor()
    static let sharedProvider: MoyaProvider<APIMovie> = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConstants.DEFAULT_TIMEOUT_INTERVAL
        let sessionManager = Session(configuration: configuration, interceptor: RequestHandler(), eventMonitors: [eventMonitor])
        return MoyaProvider<APIMovie>(session: sessionManager)
    }()
}

class RequestHandler: RequestInterceptor {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ idToken: String?) -> Void
    private let lock = NSLock()
    private var isRefreshing = false
    private var disposeBag = DisposeBag()
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == HTTPStatusCodes.Unauthorized.rawValue
                || response.statusCode == HTTPStatusCodes.Forbidden.rawValue {
            requestsToRetry.append(completion)
            if !isRefreshing {
                // retry here
                completion(.doNotRetry)
            }
            
        } else {
            completion(.doNotRetry)
        }
        
    }
}
