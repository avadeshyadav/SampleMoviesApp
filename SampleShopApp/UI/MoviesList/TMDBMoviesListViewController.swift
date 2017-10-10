//
//  TMDBMoviesListViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMoviesListViewController: TMDBBaseViewController {

    let model = TMDBMoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMovies()
    }
    
    func loadMovies() {
        
        let task = self.model.getMoviesList(with: { (listResult) in
            
            if let result = listResult as? TMDBMovieListResultItem {
                print("Received results: \(result.results.count)")
            }
            else {
                print("No results received")
            }
        })
        
        self.addOnGoingNetworkCall(task)
    }

}
