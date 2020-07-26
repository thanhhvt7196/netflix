//
//  HostAPIClient.swift
//  netflix
//
//  Created by kennyS on 21/7/20.
//

import Foundation
import RxSwift

class HostAPIClient {
    static func performApiNetworkCall<T: Codable>(router: APIMovie, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            NetworkManager.apiProvider.request(router) { result in
                switch result {
                case .failure(let error):
                    if let data = error.response?.data {
                        do {
                            let response = try JSONDecoder().decode(APIError.self, from: data)
                            observer.onError(response)
                        } catch let error {
                            print(error)
                            observer.onError(APIError(status_code: nil, status_message: ErrorMessage.errorOccur))
                        }
                    }
                    let statusCode = error.response?.statusCode
                    switch statusCode {
                    case HTTPStatusCodes.InternalServerError.rawValue:
                        observer.onError(APIError(status_code: statusCode, status_message: ErrorMessage.serverError))
                    case HTTPStatusCodes.NotFound.rawValue:
                        observer.onError(APIError(status_code: statusCode, status_message: ErrorMessage.notFound))
                    case HTTPStatusCodes.BadRequest.rawValue:
                        observer.onError(APIError(status_code: statusCode, status_message: ErrorMessage.badRequest))
                    default:
                        observer.onError(APIError(status_code: statusCode, status_message: ErrorMessage.errorOccur))
                    }
                    observer.onCompleted()
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == HTTPStatusCodes.OK.rawValue {
                        let data = response.data
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                        } catch let error {
                            print(error)
                            observer.onError(error)
                        }
                    } else {
                        let data = response.data
                        do {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            observer.onError(error)
                        } catch let error {
                            print(error)
                            observer.onError(error)
                        }
                    }
                    
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
