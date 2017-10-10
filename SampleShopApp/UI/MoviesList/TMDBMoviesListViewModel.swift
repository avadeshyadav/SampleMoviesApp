//
//  TMDBMoviesListViewModel.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

struct TMDBMovieListCellViewModel {
    
    var title: String?
    var popularity: String?
    var imageUrl: URL?

    init(with movieItem: TMDBMovieItem) {
        
        title = movieItem.title
        popularity = movieItem.popularity
        
        if let posterPath = movieItem.posterPath {
            
            let urlString = kBaseImageURLPath + posterPath
            imageUrl = URL(string: urlString)
        }
    }
}


class TMDBMoviesListViewModel {
    
    var resultItem = TMDBMovieListResultItem()

    func getMovieCellModel(for indexPath: IndexPath) -> TMDBMovieListCellViewModel {
    
        return TMDBMovieListCellViewModel(with: resultItem.results[indexPath.row])
    }
    
    func getMoviesList(with completionBlock: @escaping CompletionBlock) -> URLSessionDataTask? {
        
        let movieService = TMDBMoviesService(with: .moviesList)
        let params = getMoviesListParameters()
        return movieService.getMoviesList(with: params, onError: { (error) in
            
            completionBlock(error as AnyObject?)
            
        }) { [weak self] (data) in
            
            if let result = data as? TMDBMovieListResultItem {
                self?.resultItem.addResults(from: result)
            }
            
            completionBlock(data as AnyObject)
        }
    }
    
    func getMoviesListParameters() -> Dictionary<String, Any> {
        
        var params = Dictionary<String, Any>()
        params["sort_by"] = "release_ date.desc"
        params["page"] = resultItem.currentPage ?? 1
        return params
    }

}
