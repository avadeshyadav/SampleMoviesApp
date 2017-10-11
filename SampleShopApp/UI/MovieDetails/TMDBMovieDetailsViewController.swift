//
//  TMDBMovieDetailsViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMovieDetailsViewController: TMDBBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let model = TMDBMovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
    }
    
    //MARK: Public Methods
    func loadMovieDetails(with movieId: String) {
        model.currentMovieId = movieId
        loadMovieDetails()
    }
    
    //MARK: Private Methods
    func doInitialConfigurations() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
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


//MARK:- TableView Functionality
extension TMDBMovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Table View Delegate and Data source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBMovieDescriptionCell", for: indexPath) as! TMDBMovieListCell
//        cell.configureCell(with: model.getMovieCellModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
