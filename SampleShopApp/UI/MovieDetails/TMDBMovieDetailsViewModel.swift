//
//  TMDBMovieDetailsViewModel.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

class TMDBMovieDetailsViewModel {
    
    var currentMovieId: String? = "328111"

    func getMovieDetails(with completionBlock: @escaping CompletionBlock) -> URLSessionDataTask? {
        
        let movieService = TMDBMoviesService(with: .movieDetails)
        
        return movieService.getMovieDetails(with: currentMovieId!, onError: { (error) in
            
            completionBlock(error as AnyObject?)
            
        }) { [weak self] (data) in
            
            completionBlock(data as AnyObject)
        }
    }
    
}
