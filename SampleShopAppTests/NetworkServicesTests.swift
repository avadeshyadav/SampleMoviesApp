//
//  NetworkServicesTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest
@testable import SampleShopApp

class MockDataProvider: RequestDataProvider {
    
    var currentApiType: MoviesAPIType = .none
    var headers: Dictionary<String, String>?
    var commonParamters: Dictionary<String, String>?
    var askedHeadersCount: Int = 0
    var askedParametersCount: Int = 0
    
    init(apiType: MoviesAPIType, header: Dictionary<String, String>, commonParams: Dictionary<String, String>) {
        currentApiType = apiType
        headers = header
        commonParamters = commonParams
    }
    
    func getRequestHeaders() -> Dictionary<String, String> {
        askedHeadersCount = askedHeadersCount + 1
        return headers ?? [:]
    }
    
    func serviceCommonParameters() -> Dictionary<String, Any> {
        askedParametersCount = askedParametersCount + 1
        return commonParamters ?? [:]
    }
}

class MockResponseHandler: ResponseHandle {
    
    var currentApiType: MoviesAPIType = .none
    
    init(apiType: MoviesAPIType) {
        currentApiType = apiType
    }
    
    func parsedError(from data: Data, andError error: NSError?) -> GoCustomError? {
        return GoCustomError()
    }
    
    func parsedObject(from response: Any?) -> Any? {
        
        guard let data = response as? Data else {
            return response
        }
        
        if let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
            return responseObject
        }
        
        return response
    }
}

class MockNetworkServiceProvider: NetowrkServiceHandle {
    
    var backgroundQueue: DispatchQueue { return DispatchQueue.global(qos: .background) }
    
    @discardableResult
    func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        return URLSessionDataTask()
        
    }
    
    @discardableResult
    func postWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        return URLSessionDataTask()
        
    }
    
    @discardableResult
    func putWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        return URLSessionDataTask()
        
    }
    
    @discardableResult
    func deleteWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        return URLSessionDataTask()
    }
    
}

class NetworkServicesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  
    func testServiceTaskCreation() {
        
        let service = TMDBMoviesService(with: .moviesList)
        let task = service.getMoviesList(with: ["hi": "hello"], onError: { (error) in }) { (data) in }
        XCTAssertNotNil(task, "Network Architecture unable to initialize")
    }
    
    func testServiceWithMockHeaders() {
        
        let headers: Dictionary<String, String> = ["FirstName": "Avadesh", "LastName": "Kummar"]
        let urlString = "http://www.google.com"
        
        
        let responseHandler = BaseResponseHandler()
        let dataProvider = MockDataProvider(apiType: .moviesList, header: headers, commonParams: headers)
        let allHeaders = dataProvider.getRequestHeaders()
        let service = GoBaseNetworkService(with: responseHandler, dataProvider: dataProvider, viaNetworkService: GoURLSessionService())
        
        let task = service.getWithURL(urlString, parameters: headers)
        print("Going to print task:")
        print(task?.currentRequest ?? "")
        
        
        XCTAssertNotNil(task, "Network Architecture unable to initialize")
        XCTAssertNotNil(task?.originalRequest, "Network Architecture unable to initialize urlRequest")
        print("Asked headers count:\(dataProvider.askedHeadersCount)")
        
        XCTAssertFalse(dataProvider.askedHeadersCount > 2, "Network Architecture getHeaders Method called more than once")//1 called from this test method itself
        XCTAssertFalse(dataProvider.askedParametersCount > 1, "Network Architecture getCommonParamters Method called more than once")
        
        if let query = task?.originalRequest?.url?.query {
            print("Query: \(query)")
        }
        
        if let urlRequest = task?.originalRequest, let requestHeaders = urlRequest.allHTTPHeaderFields {
            
            for (key, value) in allHeaders {
                XCTAssertTrue(requestHeaders[key]! == value, "Network Architecture not able to attach headers to request")
            }
        }
    }
    
    func testServiceURLGetParams() {
        
        let responseHandler = BaseResponseHandler()
        let dataProvider = BaseRequestHandler()
        let commonParams = dataProvider.serviceCommonParameters()
        let urlString = "http://www.google.com"
        let getParams: Dictionary<String, String> = ["FirstName": "Avadesh", "LastName": "Kummar"]
        var allGetParams = Dictionary<String, Any>()
        allGetParams.merge(from: commonParams)
        allGetParams .merge(from: getParams)
        
        let service = GoBaseNetworkService(with: responseHandler, dataProvider: dataProvider, viaNetworkService: GoURLSessionService())
        
        let task = service.getWithURL(urlString, parameters: getParams)
        
        XCTAssertNotNil(task, "Network Architecture unable to initialize")
        XCTAssertNotNil(task?.originalRequest, "Network Architecture unable to initialize urlRequest")
        XCTAssertNotNil(task?.originalRequest, "Network Architecture unable to initialize urlRequest")
        
        XCTAssertNotNil(task?.originalRequest?.url, "Network Architecture unable to initialize url")
        XCTAssertNotNil(task?.originalRequest?.url?.query, "Network Architecture unable to encode url's paramters")
        
        if let url = task?.originalRequest?.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
            
            for item in queryItems {
                
                guard let paramValue = allGetParams[item.name] else {
                    continue
                }
                
                let paramStringValue = String(describing: paramValue)
                
                print("Key:\(item.name) myValue:\(item.value ?? "nil") receivedValue:\(paramStringValue)")
                
                if let value = item.value, value == paramStringValue {
                    allGetParams.removeValue(forKey: item.name)
                    print("Found key:\(item.name)")
                }
            }
            
            XCTAssertTrue(allGetParams.keys.count == 0, "Network Architecture unable to encode all url's paramters")
        }
    }
    
    func testServiceURLPOSTParams() {
        
        let responseHandler = BaseResponseHandler()
        let dataProvider = BaseRequestHandler()
        let commonParams = dataProvider.serviceCommonParameters()
        let postParams: Dictionary<String, String> = ["FirstName": "Avadesh", "LastName": "Kummar"]
        let urlString = "http://www.google.com"
        
        let service = GoBaseNetworkService(with: responseHandler, dataProvider: dataProvider, viaNetworkService: GoURLSessionService())
        
        let task = service.postWithURL(urlString, parameters: postParams)
        
        XCTAssertNotNil(task, "Network Architecture unable to initialize")
        XCTAssertNotNil(task?.originalRequest, "Network Architecture unable to initialize urlRequest")
        XCTAssertNotNil(task?.originalRequest?.url, "Network Architecture unable to initialize url")
        XCTAssertNotNil(task?.originalRequest?.httpBody, "Network Architecture unable to add post params")
        
        if let bodyData = task?.originalRequest?.httpBody, let jsonObject = try? JSONSerialization.jsonObject(with: bodyData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, Any> {
            
            var allPassedParams =  commonParams
            allPassedParams.merge(from: postParams)
            
            for (key, value) in jsonObject! {
                
                let paramStringValue = String(describing: value)
                
                print("Key:\(key) myValue:\(allPassedParams[key] ?? "nil") receivedValue:\(paramStringValue)")
                
                if let newValue = allPassedParams[key] as? String, newValue == paramStringValue {
                    allPassedParams.removeValue(forKey: key)
                    print("Found key:\(key)")
                }
            }
            
            XCTAssertTrue(allPassedParams.keys.count == 0, "Network Architecture unable to encode all post paramters")
        }
    }
}
