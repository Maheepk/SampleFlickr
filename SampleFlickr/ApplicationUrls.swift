//
//  ApplicationUrls.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import Foundation

struct URLS {
    
    // Base url
    static let SYS_BASE = "https://api.flickr.com/"
    
    // 
    static var PHOTOS_FEEDS : String {
        return URLS.SYS_BASE + "services/feeds/photos_public.gne"
    }
    
}
