//
//  TMDBMovieDetailsParser.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation


class TMDBMovieDetailsParser: TMDBBaseParser {
    
    override func parsedResponse(_ json: Any?) -> Any?  {
        
        guard let rawDict = json as? Dictionary<String, Any> else {
            return nil
        }
        
        if let errorCode = rawDict["status_code"], let errorMessage = rawDict["status_message"] as? String {
            return GoCustomError.customErrorWithMessage(errorMessage, errorCode: String(describing: errorCode), error: nil)
        }
        
        return TMDBMovieDetailsItem(with: rawDict)
    }
}
