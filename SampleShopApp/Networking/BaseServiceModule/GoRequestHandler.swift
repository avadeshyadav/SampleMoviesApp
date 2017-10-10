//
//  GoRequestHandler.swift
//  Goibibo
//
//  Created by Avadesh Kumar on 09/08/17.
//  Copyright © 2017 ibibo Web Pvt Ltd. All rights reserved.
//

import Foundation

protocol RequestDataProvider {
    func getRequestHeaders() -> Dictionary<String, String>
    func serviceCommonParameters() -> Dictionary<String, Any>
}

class BaseRequestHandler: NSObject, RequestDataProvider {
    
    let kContentTypeKeyName = "Content-Type"
    let kContentTypeApplicationJsonValue = "application/json"
    let kContentTypeWWWFormEncodedValue = "application/x-www-form-urlencoded"
    let kGoDeviceIdKeyName = "DEVICE-ID"
    let kFlavourKeyName = "flavour"
    
    func getRequestHeaders() -> Dictionary<String, String> {
        
        var headers = Dictionary<String, String>()
// Put common headers here, those are common througuot app
        return headers
    }
    
    func serviceCommonParameters() -> Dictionary<String, Any> {
        
        var parameters = Dictionary<String, Any>()
        parameters[kFlavourKeyName] = "iOS"
        
        return parameters
    }
}
