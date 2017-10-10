//
//  TMDBMoviesListViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMoviesListViewController: TMDBBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let model = TMDBMoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
        loadMovies()
    }
    
    //MARK: Private Methods
    func doInitialConfigurations() {
        self.title = "Movies List"
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadMovies() {
        
        let task = self.model.getMoviesList(with: { [weak self] (listResult) in
            
            if let result = listResult as? TMDBMovieListResultItem {
                print("Received results: \(result.results.count)")
                self?.tableView.reloadData()
            }
            else {
                print("No results received")
            }
        })
        
        self.addOnGoingNetworkCall(task)
    }
}

//MARK:- TableView Functionality
extension TMDBMoviesListViewController: UITableViewDelegate, UITableViewDataSource {

    //MARK: Table View Delegate and Data source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.resultItem.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBMovieListCell", for: indexPath) as! TMDBMovieListCell
        cell.configureCell(with: model.getMovieCellModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
