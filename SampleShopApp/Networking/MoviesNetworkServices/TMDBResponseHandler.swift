//
//  TMDBResponseHandler.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation


class TMDBResponseHandler: BaseResponseHandler {
    
    let kErrorKeyName = "status_message"
    let kErrorCodeKeyName = "status_code"
    
    var currentApiType: MoviesAPIType = .none
    
    init(apiType: MoviesAPIType) {
        currentApiType = apiType
    }
    
    override func customError(from responseDict: Dictionary<String, Any>?) -> GoCustomError {
        
        var errorCode: String = ""
        
        if let code = responseDict?[kErrorCodeKeyName] {
            errorCode = "\(code)"
        }
        
        let errorMessage = responseDict?[kErrorKeyName] as? String
        
        let customError = GoCustomError.customErrorWithMessage(errorMessage ?? "Unable to connect to server. Please try again." , errorCode: errorCode, error: nil)
        
        return customError
    }
    
    override func parsedObject(from response: Any?) -> Any? {
        
        return parserForAPIType(currentApiType).parsedResponse(response)
    }
    
    func parserForAPIType(_ apiType: MoviesAPIType) -> TMDBBaseParser {
        
        var parser = TMDBBaseParser()
        
        switch apiType {
            
        case .moviesList:
            parser = TMDBMoviesListParser()
            
        case .movieDetails:
            parser = TMDBMovieDetailsParser()
            
        case .none:
            break
        }
        
        return parser
    }
}
