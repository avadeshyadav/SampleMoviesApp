//
//  TMDBMoviesListViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

let kLoaderViewTag = 12121
let kLoaderViewHeight: CGFloat = 40

class TMDBMoviesListViewController: TMDBBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomMarginConstraint: NSLayoutConstraint!

    var refreshControl: UIRefreshControl?
    
    let model = TMDBMoviesListViewModel()
    
    //MARK: Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialConfigurations()
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailsController = segue.destination as? TMDBMovieDetailsViewController, let movieId = sender as? String {
            detailsController.loadMovieDetails(with: movieId)
        }
        else if let webVC = segue.destination as? TMDBWebViewController {
            webVC.loadWebPage(with: kBookingSimulationURLString)
        }
    }
    
    //MARK: Private Methods
    func doInitialConfigurations() {
        self.edgesForExtendedLayout = []
        self.title = "Movies List"
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        configureRefreshControl(on: tableView)
    }
    
    func configureRefreshControl(on tableView: UITableView) {
    
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refreshMoviesList), for: .valueChanged)
    }
    
    func refreshMoviesList() {
    
        cancelAllOnGoingCalls()
        model.isUserRefreshingList = true
        refreshControl?.beginRefreshing()
        loadMovies()
    }
    
    func loadMovies() {
        
        let task = self.model.getMoviesList(with: { [weak self] (listResult) in
            
            self?.refreshControl?.endRefreshing()
            self?.isLoadingNextPageResults(false)

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
extension TMDBMoviesListViewController: UITableViewDelegate, UITableViewDataSource, TMDBMovieListCellDelegate {

    //MARK: Table View Delegate and Data source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.resultItem.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMDBMovieListCell", for: indexPath) as! TMDBMovieListCell
        cell.configureCell(with: model.getMovieCellModel(for: indexPath))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = model.getMovieId(for: indexPath)
        self.performSegue(withIdentifier: "PushMovieDetailsScreen", sender: movieId)
    }
    
    //MARK: Lazy loading functionality
    func isLoadingNextPageResults(_ isLoading: Bool) {
       
        model.isLoadingNextPageResults = isLoading
       
        if isLoading {
            addLoaderViewForNextResults()
            tableViewBottomMarginConstraint.constant = kLoaderViewHeight
        }
        else {
            tableViewBottomMarginConstraint.constant = 0
            let view = self.view.viewWithTag(kLoaderViewTag)
            view?.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: Private Methods
    
    func addLoaderViewForNextResults() {
        let view = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - kLoaderViewHeight, width: self.view.frame.size.width, height: kLoaderViewHeight))
        view.backgroundColor = UIColor.lightGray
        view.tag = kLoaderViewTag
        
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatorView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        indicatorView.startAnimating()
        indicatorView.color = UIColor.darkGray
        indicatorView.isHidden = false
        view.addSubview(indicatorView)
        
        self.view.addSubview(view)
    }
    
    // MARK: Overriden Methods
    
    func loadNextPageResults() {
        loadMovies()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        guard  model.canLoadNextPageResults() else {
            return
        }
        
        let margin: CGFloat = 30
        let heightToLoadNextPage: CGFloat = scrollView.contentSize.height + margin
        let currentPosition: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (currentPosition >= heightToLoadNextPage) {
            isLoadingNextPageResults(true)
            loadNextPageResults()
        }
    }
    
    //MARK: TMDBMovieListCellDelegate Methods
    func didSelectBookNow(in cell: TMDBMovieListCell) {
        //Get index here, and get selected movie id to book
        self.performSegue(withIdentifier: "PushBookNowWebViewFromList", sender: nil)
    }
}
