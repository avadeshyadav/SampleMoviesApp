//
//  TMDBWebViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = urlString, let url = URL(string: urlString!) {
            
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        else {
            //Show Error and pop back
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //Public Methods
    func loadWebPage(with urlString: String) {
        self.urlString = urlString
    }

    
}
