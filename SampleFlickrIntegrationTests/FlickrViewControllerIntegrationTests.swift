//
//  FlickrViewControllerIntegrationTests.swift
//  SampleFlickr
//
//  Created by Er on 27/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import XCTest

@testable import SampleFlickr

/*
 We created this as seprate file because this contains Asynchrounus call to test so, which will take some time then normal so, we dont want to distrub another test cases.
 */

class FlickrViewControllerIntegrationTests: XCTestCase {
    
    // We set this forse unwarp because we are assure we will set in later its object.
    var serviceRequestor : FlickrServiceRequestor!
    
    override func setUp() {
        super.setUp()
        serviceRequestor = FlickrServiceRequestor()
    }
    
    // Test Cases..
    // 1. Check data is coming from cloud.
    
    func testTableViewCountIfNoData() {
        
        // Given
        
        let expectation = self.expectation(description: "Expected load flickr data from cloud to fail")
        
        // When
        
        serviceRequestor.getFlickrFeeds({ (data) in
            expectation.fulfill()
            XCTAssertTrue(data != nil)
            
        }) { (error) in
            XCTAssertTrue(error != nil)
        }
        
        // then
        self.waitForExpectations(timeout: 60, handler: nil) // As we are testing api to give us result up to 60 Seconds, if not this test will fail.
        
    }

}
