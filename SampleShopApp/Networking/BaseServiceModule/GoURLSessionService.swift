//
//  GoURLSessionService.swift
//  Goibibo
//
//  Created by Avadesh Kumar on 10/08/17.
//  Copyright © 2017 ibibo Web Pvt Ltd. All rights reserved.
//

import Foundation

enum GoURLServiceError: Swift.Error {
    case URLStringNotURLConvertible
    case UnableToEncodeParams
}

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


/*
 This class is just for testing purpose to switch between different NetworkServiceProviders. Currently all classes are under single file, will seperate it out later
 */
class GoURLSessionService: NetowrkServiceHandle {
    
    deinit {
        print("Deinit: GoURLSessionService")
    }
    
    @discardableResult
    func getWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        return self.taskWithURL(urlString, parameters: parameters, httpMethod: .get, headers: headers, requestSerializer: requestSerializer, timeout: timeout, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    @discardableResult
    func postWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        return self.taskWithURL(urlString, parameters: parameters, httpMethod: .post, headers: headers, requestSerializer: requestSerializer, timeout: timeout, successBlock: successBlock, errorBlock: errorBlock)!
    }
    
    
    @discardableResult
    func putWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        return self.taskWithURL(urlString, parameters: parameters, httpMethod: .put, headers: headers, requestSerializer: requestSerializer, timeout: timeout, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    @discardableResult
    func deleteWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        return self.taskWithURL(urlString, parameters: parameters, httpMethod: .delete, headers: headers, requestSerializer: requestSerializer, timeout: timeout, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    //MARK: Private Methods
    private func taskWithURL(_ urlString: String, parameters: Dictionary<String, Any>?, httpMethod: HTTPMethodType, headers: Dictionary<String, Any>?, requestSerializer: RequestSerializerType, timeout: TimeInterval, successBlock: NetworkAPICompletionBlock?, errorBlock: ErrorCompletionBlock?) -> URLSessionDataTask? {
        
        guard let url = try? URLEncoder().urlWith(string: urlString, parameters: parameters, httpMethod: httpMethod) else {
            return nil
        }
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = timeout
        request.addHeaders(from: headers)
        
        if URLEncoder().canEncodeParamsInURL(for: httpMethod) == false {
            serializerWith(type: requestSerializer).encode(request, paramters: parameters)
        }
        
        let localURLSession = URLSession.shared
        let task = localURLSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let responseData: Data = data, let _ : URLResponse = response, error == nil else {
                errorBlock?(data, response, error as NSError?)
                return
            }
            
            //This part needs to go out from this class, somewhere common place in parsers.
            if let responseObject = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? Dictionary<String, Any> {
                successBlock?(responseObject)
                return
            }
        }
        
        task.resume()
        return task
    }
    
    private func serializerWith(type: RequestSerializerType) -> RequestSerializable {
        
        switch type {
        case .JSON: return JSONRequestSerializer()
        case .propertyList: return PlistRequestSerializer()
        default: return RequestSerializer()
        }
    }
}

protocol URLEncodeble {
    func urlWith(string: String, parameters: Dictionary<String, Any>?, httpMethod: HTTPMethodType) throws -> URL?
    func canEncodeParamsInURL(for httpMethod: HTTPMethodType) -> Bool
}

class URLEncoder: URLEncodeble {
    
    func urlWith(string: String, parameters: Dictionary<String, Any>?, httpMethod: HTTPMethodType) throws -> URL? {
        
        guard var urlComponents = URLComponents(string: string) else {
            throw GoURLServiceError.URLStringNotURLConvertible
        }
        
        guard let params = parameters, canEncodeParamsInURL(for: httpMethod) == true else {
            return urlComponents.url
        }
        
        urlComponents.queryItems = params.map {
            URLQueryItem(name: String(describing: $0), value: String(describing: $1)) }
        return urlComponents.url
    }
    
    func canEncodeParamsInURL(for httpMethod: HTTPMethodType) -> Bool {
        
        switch httpMethod {
        case .delete, .get:
            return true
        default:
            return false
        }
    }
}


protocol RequestSerializable {
    func encode(_ request: NSMutableURLRequest, paramters: Dictionary<String, Any>?)
}

class RequestSerializer: RequestSerializable {
    
    func encode(_ request: NSMutableURLRequest, paramters: Dictionary<String, Any>?) {
        
        if let stringValue = paramters?.toPOSTString() {
            request.httpBody =  stringValue.data(using: String.Encoding.utf8)
        }
    }
}

class JSONRequestSerializer: RequestSerializable {
    
    func encode(_ request: NSMutableURLRequest, paramters: Dictionary<String, Any>?) {
        
        if let jsonData = paramters?.toJSONData() {
            request.httpBody = jsonData
        }
    }
}

class PlistRequestSerializer: RequestSerializable {
    
    func encode(_ request: NSMutableURLRequest, paramters: Dictionary<String, Any>?) {
        
        if let params = paramters, let data = try? PropertyListSerialization.data(fromPropertyList: params, format: .xml, options: 0) {
            request.httpBody = data
        }
        //            urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
    }
}


extension NSMutableURLRequest {
    
    func addHeaders(from dict: Dictionary<String, Any>?) {
        
        guard let _ = dict else {
            return
        }
        
        for (key, value) in dict! {
            self.addValue(String(describing: value), forHTTPHeaderField: key)
        }
    }
}
