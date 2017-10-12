//
//  TMDBBaseViewController.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBBaseViewController: UIViewController {

    let onGoingNetworkCalls =  NSHashTable<URLSessionDataTask>()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelAllOnGoingCalls()
    }
    
    // MARK: Public Methods
    func addOnGoingNetworkCall(_ call: URLSessionDataTask?) {
        
        if let _ = call {
            onGoingNetworkCalls.add(call)
        }
    }
    
    func cancelAllOnGoingCalls() {
        
        for urlTask in onGoingNetworkCalls.objectEnumerator() {
            
            guard let task = urlTask as? URLSessionDataTask else {
                continue
            }
            
            task.cancel()
        }
    }
}
