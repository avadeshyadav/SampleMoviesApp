//
//  TMDBMoviesNetworkService.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 09/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

enum MoviesAPIType : Int {
    case moviesList
    case movieDetails
    case none
}

typealias CompletionBlock = (Any?) -> Void


class TMDBMoviesService: GoBaseNetworkService {
    
    convenience init(with apiType: MoviesAPIType) {
        self.init()
        self.reponseHandler = TMDBResponseHandler(apiType: apiType)
        self.dataProvider = TMDBBaseRequestHandler(apiType: apiType)
        self.networkServiceHandler = GoURLSessionService()
    }

    deinit {
        print("Deinit: TMDBMoviesService")
    }
    
    @discardableResult
    func getMoviesList(with parameters: Dictionary<String, Any>, onError: NetworkAPICompletionBlock?, onSuccess: NetworkAPICompletionBlock?) -> URLSessionDataTask? {
        
        self.assignSuccessBlock(onSuccess, onError: onError)
        
        let urlString = TMDBURLBuilder().getMoviesListURL()
        let task = self.getWithURL(urlString, parameters: parameters)
        
        return task;
    }
    
    @discardableResult
    func getMovieDetails(with movieId: String, onError: NetworkAPICompletionBlock?, onSuccess: NetworkAPICompletionBlock?) -> URLSessionDataTask? {
        
        self.assignSuccessBlock(onSuccess, onError: onError)
        
        let urlString = TMDBURLBuilder().getMovieDetailsURL(with: movieId)
        let task = self.getWithURL(urlString, parameters: nil)
        
        return task;
    }
  
}

class TMDBURLBuilder {

    lazy var baseServerURL: String = kBaseServerURL
    let apiVersionV3: String = "/3/"
    
    func getMoviesListURL() -> String {
        return baseServerURL + apiVersionV3 + "discover/movie"
    }
    
    func getMovieDetailsURL(with movieId: String) -> String {
        return baseServerURL + apiVersionV3 + "movie/" + movieId
    }
    /*
     http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877 d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=release_ date.desc&page=1
     2. http://api.themoviedb.org/3/movie/328111?api_key=328c283cd27bd1877d9 080ccb1604c91
     */
}
