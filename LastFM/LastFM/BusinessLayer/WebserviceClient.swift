//
//  WebserviceClient.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 30/01/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation

typealias Headers = [String:String]
typealias Params = [String:String]
typealias JSONDict = [String:AnyObject]
typealias SuccessModelBlock = (Any) -> Void

public typealias SuccessDataBlock = (Result<(Data), Error>) -> Void
typealias FailureBlock = (AppError?) -> Void

public protocol NetworkClient {
    func callServer(requestContext: RequestContext?, completion: @escaping SuccessDataBlock)
    func cancelServerCall()
}

public struct RequestContext {
    var url: String
    var method:RequestMethod
    var params:[String:String]?
    var headers:Headers?
    var body:JSONDict?
}
extension URLRequest {
    
    mutating func setRequstHeader(params:Headers?) {
        
        guard let headers = params else { return }
        
        for (name, value) in headers {
            self.addValue(value, forHTTPHeaderField: name)
        }
    }
    mutating func setRequstBody(params:JSONDict?) {
        
        guard let bodyJson = params, self.httpMethod != RequestMethod.GET.rawValue else { return }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyJson)
        
        // insert json data to the request
        self.httpBody = jsonData
    }
}

final class WebServiceClient : NetworkClient {
   
    private var dataTask : URLSessionDataTask?
    
    // MARK: Webservice call initiator
    
    func callServer(requestContext: RequestContext?, completion: @escaping SuccessDataBlock) {
        guard let requestCtx = requestContext else {
            completion(.failure(AppError.invalidInput))
            return
        }
       
        guard let components = NSURLComponents(string:requestCtx.url) else {
            completion(.failure(AppError.urlInvalid))
            return
        }
        if requestCtx.method == RequestMethod.GET, let params = requestCtx.params {
            components.addParams(params)
        }
        
        guard let url = components.url else{
            completion(.failure(AppError.urlInvalid))
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setRequstHeader(params: requestCtx.headers)
        urlRequest.httpMethod = requestCtx.method.rawValue
        if requestCtx.method != RequestMethod.GET {
            urlRequest.setRequstBody(params: requestCtx.body)
        }
        dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, networkError) -> Void in

            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(AppError.networkError))
                return
            }
            guard networkError == nil else {
                completion(.failure(AppError.networkError))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(AppError.dataEmpty))
                return
            }
            if urlResponse.statusCode == 200 || urlResponse.statusCode == 202 || urlResponse.statusCode == 204 {
                completion(.success((jsonData)))
            }else{
               completion(.failure(AppError.networkError))
            }
            
        })
        dataTask?.resume()
    }
    
    func cancelServerCall() {
        dataTask?.cancel()
    }
}
