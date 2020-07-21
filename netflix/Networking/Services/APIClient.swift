//
//  APIClient.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class HostAPIClient {
    static func performNetworkCall(route: APIMovie) -> Observable<Response> {
        
        return Observable.create { observer in
            HostAPIClient.callRequest(with: route, and: observer)
            return Disposables.create { }
        }
    }

    static func callRequest(with route: APIMovie, and observer: AnyObserver<Response>) {
        let request = NetworkManager.sharedProvider.request(.getPopularMovies, completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
//        log.debug("Request URl: \(String(describing: request))")
        
        request
            .validate()
            .responseData { response in
//                log.debug("Response URl: \(String(describing: response.request) + "\n")")
//                log.debug("Response HTTPHeaderFields: \(String(describing: response.request?.allHTTPHeaderFields) + "\n")")
//                log.debug("Response HTTPURLResponse: \(String(describing: response.response) + "\n")")
                if let headerFields = response.response?.allHeaderFields as? [String: Any] {
                    HostAPIClient.saveResponseHeaderFields(headerFields)
                }
                do {
                    if let data = response.data {
                        if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
//                            log.debug("Response data: \(jsonData)")
                        }
                    }
                } catch {
//                    log.debug("JSONSerialization failed")
                }
                
                switch response.result {
                case .success:
                    if let value = response.value {
                        observer.onNext(Response.success(data: value))
                    }
                    
                case .failure(let errorResponse):
//                    log.debug("Error code:\(errorResponse._code)")
//                    log.debug("Server Error: \(errorResponse.localizedDescription)")
//                    log.debug("Underlying error: \(String(describing: errorResponse.underlyingError))")
                    if errorResponse.responseCode == HTTPStatusCodes.UnsupportedMediaType.rawValue {
                        HostAPIClient.showForceUpateDialog()
                    } else if errorResponse.responseCode == HTTPStatusCodes.ServiceUnavailable.rawValue {
                        let errorDetails = ErrorHelper.getErrorDetails(responseData: response.data, errorResponse: ErrorResponse.error(errorResponse.responseCode ?? 500, errorResponse.localizedDescription))
                        HostAPIClient.showMaintainDialog(content: errorDetails.displayMessage ?? "")
                        ProgressHelper.shared.hide()
                    } else if errorResponse.responseCode == nil {
                        AlertController.shared.showConfirmMessage(title: Strings.internetError,
                                                                  message: Strings.checkInternetAndTryAgain,
                                                                  confirm: Strings.retry,
                                                                  cancel: Strings.cancel,
                                                                  confirmAction: {
                                                                    ProgressHelper.shared.show()
                                    HostAPIClient.callRequest(with: route, and: observer)
                        },
                                                                  cancelAction: {})
                        ProgressHelper.shared.hide()
                        return
                    } else if errorResponse.responseCode == HTTPStatusCodes.NotFound.rawValue {
                        ProgressHelper.shared.hide()
                        observer.onNext(Response.error(errorResponse: ErrorResponse.error(404, Strings.noPageWereFound)))
                    } else {
                        observer.onNext(Response.error(errorResponse: ErrorResponse.error(errorResponse.responseCode ?? 500, errorResponse.localizedDescription), data: response.data))
                    }
                    observer.onCompleted()
                }
                
        }
    }

    static func savePictureByRequest(urlRequest: URLRequest, fileName: String) -> Observable<(String?, ErrorResponse?)> {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let request = AF.download(urlRequest, to: destination)
        return Observable.create({ observer in
            request.responseData(completionHandler: { response in
                if let headerFields = response.response?.allHeaderFields as? [String: Any] {
                    HostAPIClient.saveResponseHeaderFields(headerFields)
                }
                switch response.result {
                case .success:
                    if response.error != nil, let imagePath = response.fileURL?.path {
                        observer.onNext((imagePath, nil))
                    }
                    
                case .failure(let errorResponse):
//                    log.debug("Error code:\(errorResponse._code)")
//                    log.debug("Server Error: \(errorResponse.localizedDescription)")
//                    log.debug("Underlying error: \(String(describing: errorResponse.underlyingError))")
                    if errorResponse.responseCode == HTTPStatusCodes.UnsupportedMediaType.rawValue {
                        HostAPIClient.showForceUpateDialog()
                    } else if errorResponse.responseCode == nil {
                        HostAPIClient.showInternetError()
                    } else {
                        observer.onNext((nil, ErrorResponse.error(errorResponse.responseCode ?? 500, errorResponse.localizedDescription)))
                    }
                }
                observer.onCompleted()
            })
            return Disposables.create { }
        })
    }
    
    static func performNetworkCall(_ urlString: String, method: HTTPMethod = .post, needAddSetting: Bool = true) -> Observable<Response> {
        let request = AF.request(urlString, method: method, parameters: nil, headers: HTTPHeaders(headers))
        return Observable.create { observer in
            request
                .validate()
                .responseData { response in
                    do {
                        if let data = response.data {
                            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
//                                log.debug("Response data: \(jsonData)")
                            }
                        }
                    } catch {
//                        log.debug("JSONSerialization failed")
                    }
                    
                    switch response.result {
                    case .success:
                        if let value = response.value {
                            observer.onNext(Response.success(data: value))
                        }
                        
                    case .failure(let errorResponse):
                        if errorResponse.responseCode == HTTPStatusCodes.NotFound.rawValue {
                            observer.onNext(Response.error(errorResponse: ErrorResponse.error(404, "Not found")))
                        } else {
                            observer.onNext(Response.error(errorResponse: ErrorResponse.error(errorResponse.responseCode ?? 500, errorResponse.localizedDescription), data: response.data))
                        }
                        observer.onCompleted()
                    }
            }
            return Disposables.create { }
        }
    }
    
    static func getStatusCodeErrorType(errorDetails: ErrorDetails) -> HttpStatusCodeErrorType {
        let httpStatusCode = errorDetails.status?.intValue ?? 0
        var result = HttpStatusCodeErrorType.httpStatusCodeErrorTypeNone
        if httpStatusCode == 401 || httpStatusCode == 403 {
            result = HttpStatusCodeErrorType.httpStatusCodeErrorTypeAuthenticationError
        } else if httpStatusCode == 415 {
            result = HttpStatusCodeErrorType.httpStatusCodeErrorTypeForceUpdate
        } else if httpStatusCode >= 400, httpStatusCode < 500 {
            result = HttpStatusCodeErrorType.httpStatusCodeErrorType4xxError
        } else if httpStatusCode == 503 {
            result = HttpStatusCodeErrorType.httpStatusCodeErrorTypeMaintenance
        } else if httpStatusCode >= 500, httpStatusCode < 600 {
            result = HttpStatusCodeErrorType.httpStatusCodeErrorType5xxServerError
        }
        return result;
    }
}
