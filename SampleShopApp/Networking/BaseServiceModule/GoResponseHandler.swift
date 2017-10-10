//
//  GoResponseHandler.swift
//  Goibibo
//
//  Created by Avadesh Kumar on 09/08/17.
//  Copyright © 2017 ibibo Web Pvt Ltd. All rights reserved.
//

import Foundation

protocol Parseable {
    func parsedResponse(_ json: Any?) -> Any? //This Method should throw errors occured while parsing, and should return generic type instead of any type
}

protocol ResponseHandle {
    func parsedError(from data: Data, andError error: NSError?) -> GoCustomError?
    func parsedObject(from response: Any?) -> Any?
}

class BaseResponseHandler: ResponseHandle {
    
    /*
     This method parses the reponse error if received in JSON format, and returns GoCustomError object. You can override this method if you are not receiving error response in JSON format.
     */
    func parsedError(from responseData: Data, andError error: NSError?) -> GoCustomError? {
    
        if let responseObject = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? Dictionary<String, Any> {
            
            let customError = self.customError(from: responseObject)
            customError.error = error
            return customError
        }
        
        return nil
    }
    
    
    func parsedObject(from response: Any?) -> Any? {
        return response
    }
    
    
    func customError(from responseDict: Dictionary<String, Any>?) -> GoCustomError {
        
        let errorCode: String = "Not Handled, Derived classes should override this method"
        let customError = GoCustomError.customErrorWithMessage("Unable to connect to server. Please try again." , errorCode: errorCode, error: nil)
        
        return customError
    }

}
