//
//  TMDBMovieDetailsItem.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

struct TMDBMovieDetailsItem {
    
    var title: String?
    var overView: String?
    var posterPath: String?
    var popularity: String?
    var movieId: String?
    var generes: Array<String>?
    var languages: Array<String>?
    var releaseDate: String?
    var runTime: Int?
    
    init(with dictionary: Dictionary<String, Any>) {
        
        title = dictionary["title"] as? String
        overView = dictionary["overview"] as? String
        posterPath = dictionary["poster_path"] as? String
        popularity = dictionary["popularity"] as? String
        movieId = dictionary["id"] as? String
        releaseDate = dictionary["release_date"] as? String
        runTime = dictionary["runtime"] as? Int
        
        if let rawLanguages = dictionary["spoken_languages"] as? Array<Dictionary<String, Any>> {
            
            var languageStrings = Array<String>()
            
            for lang in rawLanguages {
                if let name = lang["name"] as? String {
                    languageStrings.append(name)
                }
            }
            
            languages = languageStrings
        }
        
        if let rawGenres = dictionary["genres"] as? Array<Dictionary<String, Any>> {
            
            var genresStrings = Array<String>()
            
            for genere in rawGenres {
                if let name = genere["name"] as? String {
                    genresStrings.append(name)
                }
            }
            
            languages = genresStrings
        }
    }
}

