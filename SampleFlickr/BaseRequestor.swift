//
//  BaseRequestor.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

let CUSTOM_ERROR_DOMAIN = "CUSTOM_ERROR_DOMAIN"
let CUSTOM_ERROR_CODE = -111
let CUSTOM_ERROR_INFO_KEY = "custom_description"

class BaseRequestor: NSObject {
    
    // Base Dispatch Group will handle group of Queues, it could be more than one in future.
    let baseDispatchGroup = DispatchGroup()
    
    override init () {
        //
    }
    
    func errorForCustomResponse(_ message: String?) -> NSError? {
        return errorForCustomResponse(message, errorCode: CUSTOM_ERROR_CODE)
    }
    
    func errorForCustomResponse(_ message: String?, errorCode: Int) -> NSError? {
        var text: String?
        if message != nil && message != "" {
            text = message
        } else {
            text = ERROR_MESSAGE_STRING
        }
        let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: errorCode, userInfo: [CUSTOM_ERROR_INFO_KEY : text!])
        return error
    }
    
    func defaultHeaders () -> [String: String] {
        // TODO: Maheep Later on Check if default headers contain Api Access token then add more headers in existing.
        
        return [:]
    }
    
    // Generic request
    func makeRequestWithparameters (_ method: HTTPMethod, urlString: URLConvertible, parameters: [String : AnyObject]?, encoding: Alamofire.ParameterEncoding, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        
        print("\nRequestHeaders:>> \(defaultHeaders())")
        print("\nRequestParameters:>> \(parameters)")
        print("\nRequestURL:>> \(urlString)")
        
        if !isServerReachable() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        }
        
        Alamofire.request(try!urlString.asURL(), method: method, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders()).responseString { (response) -> Void in
            
            print("\nRequestResponse:>> \(response)")
            
            let err = response.error
            if (err != nil) {
                let errorResponse = (error: err!)
                print(errorResponse)
                let error = self.errorForCustomResponse(errorResponse.localizedDescription, errorCode: response.response?.statusCode ?? CUSTOM_ERROR_CODE)
                failure?(error)
            }
            
            var parsedData : Any!
            
            if let responseData = response.data {
            
                self.baseDispatchGroup.enter()
                
                DispatchQueue.global(qos: .utility).async(group:self.baseDispatchGroup) {
                    parsedData = try?JSONSerialization.jsonObject(with: responseData , options: []) as! [String: Any]
                }
                
                self.baseDispatchGroup.leave()
            }
            
            self.baseDispatchGroup.notify(queue: DispatchQueue.main, execute: {
                // check for access token. key name `accessToken`. Token related shit
                if parsedData != nil {
                    success?(parsedData! as AnyObject?)
                }
            })
            
        }
    }
    
    
    // make GET Request
    func makeGETRequestWithparameters (urlString: URLConvertible, parameters: [String : AnyObject]?, encoding: Alamofire.ParameterEncoding, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        
        self.makeRequestWithparameters(.get, urlString: urlString, parameters: parameters, encoding: encoding, success: success, failure: failure)
    }
    
    // make POST Request
    func makePOSTRequestWithparameters (urlString: URLConvertible, parameters: [String : AnyObject]?, encoding: Alamofire.ParameterEncoding, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        self.makeRequestWithparameters(.post, urlString: urlString, parameters: parameters, encoding: encoding, success: success, failure: failure)
    }
    
    // make PUT Request
    func makePUTRequestWithparameters (urlString: URLConvertible, parameters: [String : AnyObject]?, encoding: Alamofire.ParameterEncoding, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        self.makeRequestWithparameters(.put, urlString: urlString, parameters: parameters, encoding: encoding, success: success, failure: failure)
    }
    
    // make PUT Request
    func makeDELETERequestWithparameters (urlString: URLConvertible, parameters: [String : AnyObject]?, encoding: Alamofire.ParameterEncoding, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        self.makeRequestWithparameters(.delete, urlString: urlString, parameters: parameters, encoding: encoding, success: success, failure: failure)
    }
}
