//
//  FlickrViewController.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import UIKit

class FlickrViewController : BaseViewController {
    
    //
    // MARK: - Outlets
    // TableView object.
    
    @IBOutlet weak var flickrTableView: UITableView! {
        didSet {
            
            //We are setting Row Height Dynamic.
            flickrTableView.rowHeight = UITableViewAutomaticDimension
            flickrTableView.estimatedRowHeight = 100
        }
    }
    
    // MARK: - Instance Properties
    //
    // ServiceRequestor object is responsible for fecthing data from server and give to ServiceResponse.
    
    let serviceRequestor : FlickrServiceRequestor = FlickrServiceRequestor()
    
    // ServiceResponse object will receive data as response.
    
    var serviceResponse: FlickrJSON? {
        didSet{
            self.title = serviceResponse?.title
        }
    }
    
    var dataSource : [FlickrItem]?
    
    // MARK: - View Lifecycle
    //
    // ViewDidLoad Calls First time when view load into memory..
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDataForFlickr()
    }
    
    // This Method is to get data from Server, later on we can implement Get data from Locally if we implement core data in our application.
    func getDataForFlickr() {
        
        // show loading indicator to make user understand, some process is going on, we can use loading screen insead as well..
        
        showIndicator("Loading..")
        
        // ServiceRequestor will get data from FlickrServices..
        
        serviceRequestor.getFlickrFeeds({[weak self] (response) in
            // Hide Loading when fetch data..
            self?.hideLoadingIndiactor()
            
            self?.serviceResponse = response as? FlickrJSON
            
            self?.dataSource = self?.serviceResponse?.items
            
            // Reload Data from tableview.. or refresh tableview to show data..
            self?.flickrTableView.reloadData()
            
        }) { [weak self] (error) in
            
            self?.hideLoadingIndiactor()
            
            print(error ?? NSError())
        }
        
        // TODO: Maheep later. ServiceRequestor get data from CoreData.
        
        
    }
    
}

//
// MARK: - UITableViewDataSource
//

extension FlickrViewController : UITableViewDelegate, UITableViewDataSource {
    
    // Get items from Flickr items in case its null then give 0 as default value in that.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    // Show Flickr tableview cell on screen.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrTableCell", for: indexPath) as! FlickrTableCell
        cell.tag = indexPath.row
        cell.allItems = self.dataSource
        
        cell.onSizeChange = { [unowned tableView] index in
            DispatchQueue.main.async {
                tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            }
        }
        
        return cell
    }

    // We are using Tableview Dynamic height as we don't know description height..
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
