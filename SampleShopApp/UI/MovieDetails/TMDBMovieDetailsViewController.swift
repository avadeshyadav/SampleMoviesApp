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
    @IBOutlet weak var bookNowContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    let model = TMDBMovieDetailsViewModel()

    //MARK: Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let webVC = segue.destination as? TMDBWebViewController {
            webVC.loadWebPage(with: kBookingSimulationURLString)
        }
    }
    
    //MARK: Public Methods
    func loadMovieDetails(with movieId: String) {
        model.currentMovieId = movieId
        self.title = title
        loadMovieDetails()
    }
   
    //MARK: IBAction Methods
    @IBAction func actionBookNow(_ sender: Any) {
        
        self.performSegue(withIdentifier: "PushBookNowWebView", sender: nil)
    }

    //MARK: Private Methods
    func doInitialConfigurations() {
        self.edgesForExtendedLayout = []
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        bookNowContainerView.addShadowWithColor(UIColor.lightGray, offset: .zero)
    }
    
    func loadMovieDetails() {
    
        activityIndicatorView?.startAnimating()
        
        let task = model.getMovieDetails {[weak self] (result) in
            
            self?.activityIndicatorView?.stopAnimating()

            if let _ = result as? TMDBMovieDetailsItem {
                print("Movie details received")
                self?.tableView.reloadData()
            }
            else {
                print("No results received show error here")
            }
        }
        
        self.addOnGoingNetworkCall(task)
    }
}

//MARK:- TableView Functionality
extension TMDBMovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Table View Delegate and Data source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = model.cellTypes[indexPath.row]
        
        switch cellType {
       
        case .imageAndDescription:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBMovieImageCell", for: indexPath) as! TMDBMovieImageCell
            cell.configureCell(with: model.getImageAndNameCellModel())
            return cell
            
        case .endDummyCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBBottomEndDummyCell", for: indexPath)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBMovieDescriptionCell", for: indexPath) as! TMDBMovieDescriptionCell
            cell.configureCell(with: model.getModelFor(cellType: cellType))
            return cell
        }
    }
}
