//
//  BaseViewController.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Adjust Navigation properties..
    
    func adjustNavigationBarProperties() {
        let back = UIBarButtonItem.init(title: "", style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.backBarButtonItem = back
    }
    
    func shouldPopViewController() -> Bool {
        return true
    }
    
    func backButtonPressed(sender: AnyObject) {
        // TODO:- Maheep, Back button functionality..
    }
}

/* BaseViewController is for Setting Cue tips, Network Check and many more..*/

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.adjustNavigationBarProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Showing Loading indicator..
    func showLoadingIndicator(message: String) {
        showIndicator(message)
    }
    
    // Hide Loading indicator..
    func hideLoadingIndiactor() {
        // Hide Loading when fetch data..
        hideIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Remove as, it could call again and call Reachablity Class.
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        
    }
    
    //MARK:- Reachability
    func networkStatusChanged(notification: NSNotification) {
        
        let status = Reach().connectionStatus()
        switch status {
        case .offline, .unknown:
            handleInternetHasBecomeInactive()
        default:
            handleInternetIsAvailable()
        }
        
    }
    
    func handleInternetIsAvailable () {
        // overriden by SubClass
    }
    
    func handleInternetHasBecomeInactive () {
        
        AlertController.showAlertFor("Oops!", message: "Your Internet Connection seems to be offline.")
    }
}

