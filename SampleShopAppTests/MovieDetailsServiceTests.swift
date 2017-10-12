//
//  MovieDetailsServiceTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest
@testable import SampleShopApp


class MovieDetailsMockServiceProvider: MockNetworkServiceProvider {
    
    @discardableResult
    override func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        backgroundQueue.asyncAfter(deadline: DispatchTime.now() + .milliseconds(10), execute: {
            
            successBlock?(self.getJSON())
        })
        
        return URLSessionDataTask()
        
    }
    
    func getJSON() -> Dictionary<String, Any> {
        
        let dictionary: Dictionary<String, Any> = [
            "overview": "Aliens land in South Africa and, with their ship totally disabled,  have no way home. Years later, after living in a slum and wearing out their welcome the 'Non-Humans' are being moved to a new tent city overseen by Multi-National United (MNU).",
            "id": 17654,
            "title": "District 9",
            "poster_path": "/axFmCRNQsW6Bto8XuJKo08MPPV5.jpg",
            "spoken_languages": [
                [
                    "iso_639_1":  "af",
                    "name": "Afrikaans"
                ],
                [
                    "iso_639_1": "zu",
                    "name": "isiZulu"
                ],
                [
                    "iso_639_1": "en",
                    "name": "English"
                ]],
            "genres": [
                [
                    "id": 878,
                    "name": "Science Fiction"], [
                        "id": 877,
                        "name": "Technology"]],
            "runtime": 112,
            "release_date": "2009-08-05",
            "popularity": 11.589835
        ]
        
        return dictionary
    }
}


class MovieDetailsServiceTests: XCTestCase {
    
    func testMovieDetailsService() {
        
        let responseHandler = TMDBResponseHandler(apiType: .movieDetails)
        let dataProvider = TMDBBaseRequestHandler(apiType: .movieDetails)
        
        let urlSessionServiceProvider = GoURLSessionService()
        let mockNetworkServiceProvider = MovieDetailsMockServiceProvider()
        
        callGetMovieDetailsApi(via: urlSessionServiceProvider, withDataProvider: dataProvider, handleResponseWith: responseHandler)
        callGetMovieDetailsApi(via: mockNetworkServiceProvider, withDataProvider: dataProvider, handleResponseWith: responseHandler)
    }
    
    
    func callGetMovieDetailsApi(via serviceProvider: NetowrkServiceHandle, withDataProvider dataProvider: RequestDataProvider, handleResponseWith responseHandler: ResponseHandle) {
        
        let serviceProviderString =  String(describing: serviceProvider)
        let dataProviderString = String(describing: dataProvider)
        let responseHandlerString = String(describing: responseHandler)
        
        var viaText = "via::\n Service Provider: \(serviceProviderString) "
        viaText.append("\n Data Provider: \(dataProviderString) ")
        viaText.append("\n Response Handler: \(responseHandlerString) ")
        
        let service = TMDBMoviesService(with: responseHandler, dataProvider: dataProvider, viaNetworkService: serviceProvider)
        
        weak var resultExpectation = expectation(description:  "TMDBMoviesService expectation :\(viaText)")
        
        _ = service.getMovieDetails(with: "17654", onError: { (error) in
            
            XCTAssertTrue(false, "TMDBMoviesService: Received Error: \(viaText)")
            
        }) { (data) in
            
            if let movieDetails = data as? TMDBMovieDetailsItem {
                XCTAssertNotNil(movieDetails.movieId, "TMDBMoviesService: Recevied movie details with invalid movieId :\(viaText)")
                XCTAssertNotNil(movieDetails.title, "TMDBMoviesService: Recevied movie details with invalid movie title :\(viaText)")
            } else {
                XCTAssertTrue(false, "TMDBMoviesService: Failed to get response as TMDBMovieDetailsItem :\(viaText)")
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


