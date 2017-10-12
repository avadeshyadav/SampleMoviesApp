//
//  MovieListModelTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 13/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest
@testable import SampleShopApp

class MovieListModelTests: XCTestCase {
    
    let model = TMDBMoviesListViewModel()
    let dataProvider = MovieListDataProvider()
    
    func fillResultListItem(from details: Dictionary<String, Any>) {
    
        guard let listResultItem = TMDBMoviesListParser().parsedResponse(details) as? TMDBMovieListResultItem else {
            XCTAssertTrue(false, "Parser failed to process response and unable to parse TMDBMovieListResultItem")
            return
        }
        
        model.resultItem = listResultItem

    }
    
    func testTMDBMovieListCellViewModel() {
        
        let rawDetails = dataProvider.getSampleJSON()
        fillResultListItem(from: rawDetails)
        
        if let results = rawDetails["results"] as? Array<Dictionary<String, Any>>, let firstResult = results.first {
            
            let cellViewModel = model.getMovieCellModel(for: IndexPath(row: 0, section: 0))
            
            let title = firstResult["title"] as? String
            XCTAssertTrue(cellViewModel.title == title, "Title Value is wrongly formed in TMDBMovieListCellViewModel")
            
            var popularity: String?
            if let value =  firstResult["popularity"] as? Double {
                popularity = "Popularity: " + String(format: "%.2f", value)
            }
            XCTAssertTrue(cellViewModel.popularity == popularity, "popularity Value is wrongly formed in TMDBMovieListCellViewModel")
            
            
            var imageUrl: URL?
            if let posterPath = firstResult["poster_path"] as? String {
                let urlString = kBaseImageURLPath + posterPath
                imageUrl = URL(string: urlString)
            }
            XCTAssertTrue(cellViewModel.imageUrl == imageUrl, "imageUrl Value is wrongly formed in TMDBMovieListCellViewModel")
            
        }
    }
    
    func testGetMovieIdMethod() {
        
        fillResultListItem(from: dataProvider.getSampleJSON())
        
        let movieId = model.getMovieId(for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(movieId, "getMovieId method unable to return a valid movie id")
    }
}

class MovieListDataProvider {

    func getSampleJSON() -> Dictionary<String, Any> {
        
        let dictionary: Dictionary<String, Any> = [
            "total_pages": 16403,
            "page": 2,
            "results": [
                [
                    "id": 17640,
                    "popularity": 2.109182,
                    "poster_path": "/jDjRMXdLkRt5V2KWmQ53KdnhkO0.jpg",
                    "title": "It's Always Fair Weather"
                ],
                [
                    "id": 24349,
                    "popularity": 2.770492,
                    "poster_path": "/jmcwJSC33VmUnfavMcLZajNqCrM.jpg",
                    "title": "Minnie and Moskowitz",
                    ]],
            "total_results": 328049]
        
        return dictionary
    }

}
