//
//  FlickrServiceRequestor.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

//MARK: Model classes for Flickr

class FlickrJSON: BaseResponse {
    
    override func mapping(map: Map) {
        self.title <- map["title"]
        self.link <- map["link"]
        self.des <- map["description"]
        self.modified <- map["modified"]
        self.generator <- map["generator"]
        self.items <- map["items"]
    }
    
    var title: String?
    var link: String?
    var des: String?
    var modified: String?
    var generator: String?
    var items: [FlickrItem]?
}


class FlickrItem: BaseResponse {
    
    var title: String?
    var link: String?
    var media: FlickrMedia?
    var date_taken: String?
    var des: String?
    var published: String?
    var author: String?
    var author_id: String?
    var tags: String?
    
    var attributeStrings : NSAttributedString?
    var atIndex: Int?
    
    override func mapping(map: Map) {
        self.title <- map["title"]
        self.link <- map["link"]
        self.media <- map["media"]
        self.date_taken <- map["date_taken"]
        self.des <- map["description"]
        self.published <- map["published"]
        self.author <- map["author"]
        self.author_id <- map["author_id"]
        self.tags <- map["tags"]
    }
    
}

class FlickrMedia: BaseResponse {
   
    var m: String?
    
    override func mapping(map: Map) {
        self.m <- map["m"]
    }
    
}

//
// MARK: Service Requestor
//
//-- Service Requestor to get Flickr Feeds from Cloud.

class FlickrServiceRequestor: BaseRequestor {
    
    func getFlickrFeeds(_ success: @escaping NetworkSuccessHandler, failure: @escaping NetworkFailureHandler)  {
        
        // URL for Photo Feeds..
        var urlString = URLS.PHOTOS_FEEDS
        
        // As We want json response so, we add ?format=json in urlString..
        
        urlString += "?lang=en-us&format=json&nojsoncallback=1"
        
        makeGETRequestWithparameters(urlString:urlString, parameters: nil /*paramter will be nil as its get request*/
            , encoding: JSONEncoding.default, success: { (object) in
            if  let response : FlickrJSON = Mapper<FlickrJSON>().map(JSON: object as! [String : Any]) {
                success(response)
            } else {
             failure(self.errorForCustomResponse(nil))
            }
        }, failure: failure)
        
    }
    
}

