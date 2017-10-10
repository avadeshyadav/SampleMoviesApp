//
//  TMDBMovieDetailsViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMovieDetailsViewController: TMDBBaseViewController {

    let model = TMDBMovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadMovieDetails() {
    
        let task = model.getMovieDetails {[weak self] (result) in
            
            if let movieDetails = result as? TMDBMovieDetailsItem {
                print("Movie details received")
            }
            else {
                print("No results received")
            }
        }
        
        self.addOnGoingNetworkCall(task)

    }

}
