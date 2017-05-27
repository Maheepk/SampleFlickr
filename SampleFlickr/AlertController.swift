//
//  AlertController.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import Foundation
import UIKit

// MARK: Show Normal Alerts used in application.

class AlertController : UIAlertController {
    
    class func showAlertForMessage (message: String?) {
        showAlertFor(nil, message: message)
    }
    
    class func showAlertFor (_ title: String?, message: String?) {
        showAlertFor(title, message: message, okButtonTitle: "Ok", okAction: nil)
    }
    
    class func showAlertFor (_ title: String?, message: String?, okButtonTitle: String?, okAction: (()->Void)?) {
        showAlertFor(title, message: message, okButtonTitle: okButtonTitle, okAction: okAction, cancelButtonTitle: nil, cancelAction: nil)
    }
    
    class func showAlertFor (_ title: String?, message: String?, okButtonTitle: String?, okAction: (()->Void)?, cancelButtonTitle: String?, cancelAction: (()->Void)?) {
        
        let alertVC = alertForTitle(title, message: message, okButtonTitle: okButtonTitle, willHaveAutoDismiss:nil, okAction: okAction, cancelButtonTitle: cancelButtonTitle, cancelAction: cancelAction)
        
        presentAlertVC(alertVC)
    }
    
    class func alertForTitle (_ title: String?, message: String?, okButtonTitle: String?, willHaveAutoDismiss: Bool?, okAction: (()->Void)?, cancelButtonTitle: String?, cancelAction: (()->Void)?) -> AlertController {
        
        return AlertController.alertForTitle(title, message: message, okButtonTitle: okButtonTitle, willHaveAutoDismiss: willHaveAutoDismiss, okAction: okAction, cancelButtonTitle: cancelButtonTitle, cancelAction: cancelAction)
    }
    
    class func presentAlertVC (_ alertVC: UIViewController) {
        guard let viewController = topMostController() else {
            return
        }
        
        viewController.present(alertVC, animated: true, completion: nil)
    }

}
