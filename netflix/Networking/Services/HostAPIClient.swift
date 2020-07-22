//
//  HostAPIClient.swift
//  netflix
//
//  Created by kennyS on 21/7/20.
//

import Foundation
import RxSwift

class HostAPIClient {
    //    static func performApiNetworkCall<T: Codable>(router: APIMovie,
    //                                                           type: T.Type) -> Observable<APIResult<T, APIError>> {
    //        return Observable.create { observer in
    //            NetworkManager.apiProvider.request(router) { result in
    //                switch result {
    //                case .failure(let error):
    //                    observer.onNext(APIResult(error: APIError(status: error.response?.statusCode,
    //                                                              message: error.localizedDescription)))
    //                case .success(let moyaResponse):
    //                    let statusCode = moyaResponse.statusCode
    //
    //                    switch statusCode {
    //                    case HTTPStatusCodes.OK.rawValue..<HTTPStatusCodes.MultipleChoices.rawValue:
    //                        let data = moyaResponse.data
    //                        do {
    //                            let response = try JSONDecoder().decode(T.self, from: data)
    //                            observer.onNext(APIResult.success(response))
    //                        } catch {
    //                            observer.onNext(APIResult.failure(APIError(status: nil, message: "Client Error")))
    //                        }
    //                    default:
    //                        observer.onNext(APIResult.failure(APIError(status: statusCode, message: "Server Error")))
    //                    }
    //                }
    //            }
    //            return Disposables.create()
    //        }
    //    }
    
    static func performApiNetworkCall<T: Codable>(router: APIMovie, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            NetworkManager.apiProvider.request(.getPopularMovies) { result in
                switch result {
                case .failure(let error):
                    if let data = error.response?.data {
                        do {
                            let response = try JSONDecoder().decode(APIError.self, from: data)
                            observer.onError(response)
                        } catch let error {
                            print(error)
                            observer.onError(APIError(status: nil, message: ErrorMessage.errorOccur))
                        }
                    }
                    let statusCode = error.response?.statusCode
                    switch statusCode {
                    case HTTPStatusCodes.InternalServerError.rawValue:
                        observer.onError(APIError(status: statusCode, message: ErrorMessage.serverError))
                    case HTTPStatusCodes.NotFound.rawValue:
                        observer.onError(APIError(status: statusCode, message: ErrorMessage.notFound))
                    case HTTPStatusCodes.BadRequest.rawValue:
                        observer.onError(APIError(status: statusCode, message: ErrorMessage.badRequest))
                    default:
                        observer.onError(APIError(status: statusCode, message: ErrorMessage.errorOccur))
                    }
                    observer.onCompleted()
                case .success(let response):
                    let data = response.data
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(object)
                    } catch let error {
                        print(error)
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
