//
//  BaseResponse.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: NSObject, Mappable {
    
    required override init() {
        //
    }
    
    required init?(map: Map){
        // overrriden by SubClass
    }
    
    func mapping(map: Map) {
        // overrriden by SubClass
    }
}


