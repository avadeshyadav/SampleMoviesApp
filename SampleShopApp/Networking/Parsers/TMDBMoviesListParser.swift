//
//  TMDBMoviesListParser.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation


class TMDBMoviesListParser: TMDBBaseParser {
    
    override func parsedResponse(_ json: Any?) -> Any?  {
        
        guard let rawDict = json as? Dictionary<String, Any> else {
            return nil
        }
        
        if let errors = rawDict["errors"] as? Array<String> {
            return GoCustomError.customErrorWithMessage(errors.joined(), errorCode: "ReceivedServerError", error: nil)
        }
        
        let resultObject = TMDBMovieListResultItem()
        resultObject.currentPage = rawDict["page"] as? Int
        resultObject.totalPages = rawDict["total_pages"] as? Int
        
        if let rawResults = rawDict["results"] as? Array<Dictionary<String, Any>> {
        
            var results = Array<TMDBMovieItem>()

            for dict in rawResults {
            
                let movieItem = TMDBMovieItem(with: dict)
                results.append(movieItem)
            }
            
            resultObject.results = results
        }
        
        return resultObject
    }
    
}
