//
//  Dictionary+Additions.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation


extension Dictionary {
    
    mutating func merge(from dict: Dictionary<Key,Value>) {
        
        for (key, value) in dict {
            self[key] = value
        }
    }
    
    func toPOSTString() -> String? {
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = self.map {
            URLQueryItem(name: String(describing: $0), value: String(describing: $1)) }
        return urlComponents.percentEncodedQuery
    }
    
    func toJSONData() -> Data? {
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
}

