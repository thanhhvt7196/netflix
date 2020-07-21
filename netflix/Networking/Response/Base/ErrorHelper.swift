//
//  ErrorHelper.swift
//  geo
//
//  Created by thanh tien on 9/24/19.
//

import Foundation

class ErrorHelper {
    class func getErrorDetails(responseData: Data?, errorResponse: ErrorResponse) -> ErrorDetails {
        if let data = responseData {
            do {
                let errorDetails = try JSONDecoder().decode(ErrorDetails.self, from: data)
//                log.debug("Server error response: \(errorDetails.message ?? "")")
                return errorDetails
            } catch let error {
//                log.debug("Model conversion failed! error: \(error)")

                let errorDetails = ErrorDetails(status: IntStringValue.int(errorResponse.code), displayText: errorResponse.description)
//                log.debug(errorDetails)
                return errorDetails
            }
        } else {
            let errorDetails = ErrorDetails(status: IntStringValue.int(errorResponse.code), displayText: errorResponse.description)
//            log.debug(errorDetails)
            return errorDetails
        }
    }
}
