//
//  TMDBBaseRequestHandler.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation


class TMDBBaseRequestHandler: BaseRequestHandler {

    var currentApiType: MoviesAPIType = .none
    let kTMDBAPIKeyName: String = "api_key"
    let kTMDBAPIValueName: String = "b53af91bdaaa26dd8e5c746c9d04357b"
    
    
    init(apiType: MoviesAPIType) {
        currentApiType = apiType
    }
    
    override func getRequestHeaders() -> Dictionary<String, String> {
        
        var headers: Dictionary<String, String> = super.getRequestHeaders()
        headers[kContentTypeKeyName] = kContentTypeApplicationJsonValue
        
        return headers
    }
    
    override func serviceCommonParameters() -> Dictionary<String, Any> {
        
        var parameters: Dictionary<String, Any> = super.serviceCommonParameters()
        parameters[kTMDBAPIKeyName] = kTMDBAPIValueName
        
        return parameters
    }
}
