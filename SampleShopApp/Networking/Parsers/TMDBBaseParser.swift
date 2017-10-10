//
//  TMDBBaseParser.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

class TMDBBaseParser: Parseable {
    
    var apiType: MoviesAPIType = .none
    
    func parsedResponse(_ json: Any?) -> Any?  {
        return json;
    }
}
