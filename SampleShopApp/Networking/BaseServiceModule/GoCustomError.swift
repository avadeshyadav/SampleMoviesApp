//
//  GoCustomError.swift
//  Goibibo
//
//  Created by Avadesh Kumar on 09/08/17.
//  Copyright © 2017 ibibo Web Pvt Ltd. All rights reserved.
//

import Foundation

class GoCustomError: NSObject {
    
    var errorCode: String? = ""
    var statusCode: Int = 0
    var message: String?
    var error: NSError?
    
    static func customErrorWithMessage(_ message: String?, errorCode: String?, error: NSError?) -> GoCustomError {
        
        let customError = GoCustomError()
        
        customError.message = message
        customError.errorCode = errorCode
        customError.error = error
        
        return customError
    }
    
    static func customErrorWithNSError(_ error: NSError?) -> GoCustomError {
        
        let customError = GoCustomError()
        
        customError.message = error?.localizedFailureReason
        
        if let _ = error {
            customError.errorCode = "\(error!.code)"
        }
        
        customError.error = error
        
        return customError
    }
}
