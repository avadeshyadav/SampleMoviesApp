//
//  MoviesListServiceTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest
@testable import SampleShopApp

class MoviesListMockServiceProvider: MockNetworkServiceProvider {
    
    @discardableResult
    override func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        backgroundQueue.asyncAfter(deadline: DispatchTime.now() + .milliseconds(10), execute: {
            
            successBlock?(self.getJSON())
        })
        
        return URLSessionDataTask()
        
    }
    
    func getJSON() -> Dictionary<String, Any> {
        
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


class MoviesListServiceTests: XCTestCase {
    
    func testMovieListService() {
        
        let responseHandler = TMDBResponseHandler(apiType: .moviesList)
        let dataProvider = TMDBBaseRequestHandler(apiType: .moviesList)
        
        let urlSessionServiceProvider = GoURLSessionService()
        let mockNetworkServiceProvider = MoviesListMockServiceProvider()
        
        callGetMovieListsApi(via: urlSessionServiceProvider, withDataProvider: dataProvider, handleResponseWith: responseHandler)
        callGetMovieListsApi(via: mockNetworkServiceProvider, withDataProvider: dataProvider, handleResponseWith: responseHandler)
    }
    
    
    func callGetMovieListsApi(via serviceProvider: NetowrkServiceHandle, withDataProvider dataProvider: RequestDataProvider, handleResponseWith responseHandler: ResponseHandle) {
        
        let serviceProviderString =  String(describing: serviceProvider)
        let dataProviderString = String(describing: dataProvider)
        let responseHandlerString = String(describing: responseHandler)
        
        var viaText = "via::\n Service Provider: \(serviceProviderString) "
        viaText.append("\n Data Provider: \(dataProviderString) ")
        viaText.append("\n Response Handler: \(responseHandlerString) ")
        
        let service = TMDBMoviesService(with: responseHandler, dataProvider: dataProvider, viaNetworkService: serviceProvider)
        
        weak var resultExpectation = expectation(description:  "TMDBMoviesService expectation :\(viaText)")
        
        let params: Dictionary<String, Any> = ["sort_by": "release_ date.desc", "page": 1]
        _ = service.getMoviesList(with: params, onError: { (error) in
            
            XCTAssertTrue(false, "TMDBMoviesService: Received Error: \(viaText)")
            
        }) { (data) in
            
            if let result = data as? TMDBMovieListResultItem {
                XCTAssertNotNil(result.currentPage, "TMDBMoviesService: Recevied movies list with invalid current page :\(viaText)")
                XCTAssertTrue(result.results.count != 0, "TMDBMoviesService: Recevied movie list with 0 results :\(viaText)")
            } else {
                XCTAssertTrue(false, "TMDBMoviesService: Failed to get response as TMDBMovieListResultItem :\(viaText)")
            }
            
            resultExpectation?.fulfill()
            resultExpectation = nil
        }
        
        let timeOut = service.apiTimeOutIntervalInSeconds
        
        if let _ = resultExpectation {
            wait(for: [resultExpectation!], timeout: timeOut)
        }
        else {
            print("expectation is nil")
        }
    }

    
}
