//
//  TMDBMovieListItem.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

class TMDBMovieListResultItem {
    
    var results = Array<TMDBMovieItem>()
    var currentPage: Int64? = 1
    var totalPages: Int64? = 0
    
    func addResults(from newObject: TMDBMovieListResultItem) {
    
        if let newPage = newObject.currentPage {
            
            self.currentPage = newPage
            results.append(contentsOf: newObject.results)
        }
    }
}

struct TMDBMovieItem {
   
    var posterPath: String?
    var title: String?
    var popularity: Double?
    var movieId: String?
    
    init(with dict: Dictionary<String, Any>) {
        
        self.title = dict["title"] as? String
       
        if let value = dict["id"] as? Int64 {
            self.movieId = "\(value)"
        }
        
        self.posterPath = dict["poster_path"] as? String
        self.popularity = dict["popularity"] as? Double
    }
}

//https://image.tmdb.org/t/p/w320/WLQN5aiQG8wc9SeKwixW7pAR8K.jpg
