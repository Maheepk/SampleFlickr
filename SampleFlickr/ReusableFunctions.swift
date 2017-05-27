//
//  ReusableFunctions.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//
//  IN this file, will write all function that are reusable in all files of swift. like loading, font changes, isServerReachable etc.
//

import Foundation
import UIKit
import EZLoadingActivity

// Ping server to check if network is available or not.
func isServerReachable() -> Bool {
    var reachable = false
    let status = Reach().connectionStatus()
    switch status {
    case .unknown, .offline:
        reachable = false
    default:
        reachable = true
    }
    return reachable
}

// Visiable Loading on Screen .
func showIndicator(_ message: String) {
    EZLoadingActivity.show(message, disableUI: true)
}

// Hide Loading on Screen .
func hideIndicator() {
    EZLoadingActivity.hide()
}

// Delegate object from AppDelegate if we need in future.
var _delegateApplication : AppDelegate?
func sharedAppDelegate() -> AppDelegate? {
    return _delegateApplication
}

// Get Top Controller.

func topMostController() -> UIViewController? {
    
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let pVC = presentedVC?.presentedViewController
    {
        presentedVC = pVC
    }
    
    if presentedVC == nil {
        print("Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
    }
    
    return presentedVC
}

//
// This function will convert datString to HTML data, as we want to track String with Tag so, we are using Tuple in that case.
//
func updateStringToHTML(_ dataString: String, tag : Int) -> (NSAttributedString?, Int) {
    let encodedData = dataString.data(using: String.Encoding.utf8)!
    let attributedOptions : [String: AnyObject] = [
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
        NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject]
    return  (try?NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil), tag)
}

