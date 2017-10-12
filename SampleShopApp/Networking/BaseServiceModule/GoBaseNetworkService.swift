//
//  GoBaseNetworkService.swift
//  Goibibo
//
//  Created by Avadesh Kumar on 09/08/17.
//  Copyright © 2017 ibibo Web Pvt Ltd. All rights reserved.
//

import Foundation

@objc enum RequestSerializerType: Int {
    case HTTP, JSON, propertyList
}

typealias ErrorCompletionBlock = (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void
typealias NetworkAPICompletionBlock = (Any?) -> Void


/*
 This protocol defines the methods that can be implemented to act any class as a NetworkServiceProvider, your NetworkServiceProvider may be internally using any approach to get the Data from server, either using AFNetworking, Alamofire, custom URLSession implemenations like IBSVURLConnection or any other implementation
 */
protocol NetowrkServiceHandle {
    
    @discardableResult
    func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask?
    
    @discardableResult
    func postWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask?
    
    @discardableResult
    func putWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask?
    
    @discardableResult
    func deleteWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask?
}

/*Currently Implemented only GET and POST calls, we can also create only one method to support all HTTP method types by taking it as argument*/
class GoBaseNetworkService: NSObject {
    
    var successCompletionBlock: NetworkAPICompletionBlock?
    var failureCompletionBlock: NetworkAPICompletionBlock?
    
    var apiTimeOutIntervalInSeconds: TimeInterval = 60.0
    var numberOfRetryAttempts: Int = 0
    
    var reponseHandler: ResponseHandle?
    var dataProvider: RequestDataProvider?
    var networkServiceHandler: NetowrkServiceHandle?
    var requestSerializerType: RequestSerializerType = .JSON
    
    lazy var backgroundQueue: OperationQueue = {
    
        let queue = OperationQueue()
        queue.qualityOfService = .background
        return queue
    }()
    
    convenience init(with responseHandler: ResponseHandle, dataProvider: RequestDataProvider, viaNetworkService: NetowrkServiceHandle) {
       
        self.init()

        self.reponseHandler = responseHandler
        self.dataProvider = dataProvider
        self.networkServiceHandler = viaNetworkService
    }
    
    deinit {
        backgroundQueue.cancelAllOperations()
        print("Deinit: GoBaseNetworkService")
    }
    
    //MARK: Public Methods
    
    /*
     This method is simply assigning it's instances of success/error block and the loadingContainerView.
     Arguments:
     onSuccess: This is the success block which will be called when received success response from the server.
     onError: This is the error block which will be called when received error response from the server/or any error connecting to server.
     */
    //Need to implement error handling using single block without nil, as explained in this talk: https://academy.realm.io/posts/sommer-panage-writing-your-ui-swiftly/
    func assignSuccessBlock(_ onSuccess: NetworkAPICompletionBlock?, onError: NetworkAPICompletionBlock?) {
        
        successCompletionBlock = onSuccess
        failureCompletionBlock  = onError
    }
    
    /*
     This method fetches data from the url as HTTP GET request. You must initialize/pass dataProvider, networkServiceHandler, reponseHandler before calling this method.
     Arguments:
     urlString: It is the complete url string of the network api call
     parameters: The paramters will be added to the url as passed in GET calls
     
     Return Type:
     URLSessionDataTask: instance of URLSessionDataTask, you can manually perform any operation like cancelling the ongoing network call, on the returned instance 
     */
    @discardableResult
    func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?) -> URLSessionDataTask? {
        
        let params = getCommonParamtersAppended(to: parameters)
        let headers = dataProvider?.getRequestHeaders()
        
        return networkServiceHandler?.getWithURL(urlString, parameters: params, headers: headers, requestSerializer: requestSerializerType, timeout: apiTimeOutIntervalInSeconds, successBlock: { (rawResponse) in
           
            self.backgroundQueue.addOperation {// Using background queue so that no need to worry about the thread on which this block is getting called
                self.didReceiveResponseWithObject(rawResponse)
            }
            
        }, errorBlock: { (responseData, urlResponse, error) in
            
            self.backgroundQueue.addOperation {
                
                self.didReceiveError(error, responseData: responseData, urlResponse: urlResponse, retryHandler: {
                    self.getWithURL( urlString, parameters: params)
                })
            }
        })
    }
    
    /*
     This method posts data on the url as HTTP POST request. You must initialize/pass dataProvider, networkServiceHandler, reponseHandler before calling this method.
     Arguments:
     urlString: It is the complete url string of the network api call
     parameters: The paramters will be sent as body of the POST api call
     
     Return Type:
     URLSessionDataTask: instance of URLSessionDataTask, you can manually perform any operation like cancelling the ongoing network call, on the returned instance
     */
    @discardableResult
    func postWithURL(_ urlString: String, parameters: Dictionary<String, Any>?) -> URLSessionDataTask? {
        
        let params = getCommonParamtersAppended(to: parameters)
        let headers = dataProvider?.getRequestHeaders()
        
        return networkServiceHandler?.postWithURL(urlString, parameters: params, headers: headers, requestSerializer: requestSerializerType, timeout: apiTimeOutIntervalInSeconds, successBlock: { (rawResponse) in
            
            self.backgroundQueue.addOperation {// Using background queue so that no need to worry about the thread on which this block is getting called
                self.didReceiveResponseWithObject(rawResponse)
            }
            
        }, errorBlock: { (responseData, urlResponse, error) in
         
            self.backgroundQueue.addOperation {
                
                self.didReceiveError(error, responseData: responseData, urlResponse: urlResponse, retryHandler: {
                    self.postWithURL( urlString, parameters: params)
                })
            }
        })
    }
    
    //MARK: Private Methods
    private func getCommonParamtersAppended(to parameters: Dictionary<String, Any>?) -> Dictionary<String, Any> {
        
        var params = dataProvider?.serviceCommonParameters() ?? Dictionary<String, Any>()
        
        if let apiParams = parameters {
            params.merge(from: apiParams)
        }
        
        return params;
    }
    
    private func handleInvalidResponseWithDetails(_ details: Any?) {
        
        var error: NSError?
        
        if let passedError = details as? NSError {
            error =  NSError(domain: passedError.domain, code: passedError.code, userInfo: [NSLocalizedFailureReasonErrorKey: passedError.localizedDescription])
        }
        else {
            let failureReason: String = details != nil ? "\(details!)" : "No response received from server"
            error =  NSError(domain: "", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: failureReason])
        }
       
        callFailureBlockOnMainQueue(with: GoCustomError.customErrorWithNSError(error))
    }
    
    private func callFailureBlockOnMainQueue(with error: GoCustomError?) {
       
        DispatchQueue.main.async {
            self.failureCompletionBlock?(error)
            self.failureCompletionBlock = nil
        }
    }
    
    private func callSuccessBlockOnMainQueue(with result: Any?) {
        
        DispatchQueue.main.async {
            self.successCompletionBlock?(result)
            self.successCompletionBlock = nil
        }
    }
    
    private func didReceiveResponseWithObject(_ response: Any?) {
        
        let result = reponseHandler?.parsedObject(from: response)
        
        if let customError = result as? GoCustomError {//This condition is put here, just in case for old backend apis, error is coming with 200 status code, in success block, so the corresponding parser will return GoCustomError instance, and failure block will be called.
            callFailureBlockOnMainQueue(with: customError)
        }
        else if let _ = result {
            callSuccessBlockOnMainQueue(with: result)
        }
        else {
            self.handleInvalidResponseWithDetails(response)
        }
    }
    
    private func didReceiveError(_ error: NSError?, responseData: Data?, urlResponse: URLResponse?, retryHandler: (() -> Void)? ) {
        
        let errorCode: Int? = error?.code
        if errorCode == NSURLErrorCancelled {
            return
        }
        
        if numberOfRetryAttempts != 0 {
            numberOfRetryAttempts = numberOfRetryAttempts - 1
            retryHandler?()
            return
        }
        
        guard let receivedData = responseData else {
            
//            let internetReachability = Reachability.forInternetConnection()
//            if internetReachability?.isReachable() == false {
//                let failureReason = "You appear to be offline. Please check your internet connection."
//                self.handleInvalidResponseWithDetails(failureReason)
//            }
//            else {
                self.handleInvalidResponseWithDetails(error)
           // }
            return
        }
        
        if let customError = reponseHandler?.parsedError(from: receivedData, andError: error) {
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                customError.statusCode = httpResponse.statusCode
            }
            
            callFailureBlockOnMainQueue(with: customError)
        }
        else {
            self.handleInvalidResponseWithDetails(responseData)
        }
    }

}
