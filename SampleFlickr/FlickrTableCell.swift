//
//  FlickrTableCell.swift
//  SampleFlickr
//
//  Created by Er on 26/05/17.
//  Copyright © 2017 Er. All rights reserved.
//

import UIKit
import SDWebImage

class FlickrTableCell: UITableViewCell {
    
    //
    // MARK: - Outlets
    //
    /*Set profile image getting from FlickrItem media and Description, Author and title of Flickr*/

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //
    // MARK: - Instance Properties
    //
    
    static var disGroup = DispatchGroup()
    
    var allItems : [FlickrItem]? {
        didSet {
            self.dataSource = allItems?[self.tag]
        }
    }
    
    // When data comes we are giving that into Labels, etc.
    
    var dataSource: FlickrItem? {
        
        didSet {
            profileImage.sd_setImage(with: URL(string: dataSource?.media?.m ?? ""))
            
            if let attributeString = dataSource?.attributeStrings {
                descriptionLabel.attributedText = attributeString
            } else {
                self.getDataFromString(self.tag)
                descriptionLabel.text = "Loading.."
            }
            
            authorLabel.text = (dataSource?.author ?? "").replacingOccurrences(of: " ", with: "")
            titleLabel.text = (dataSource?.title ?? "").replacingOccurrences(of: " ", with: "")
            
            descriptionLabel.sizeToFit()
            
            updateConstraints()
        }
    }
    
    /**Block to be invoked when text view changes its content size.*/
    
    var onSizeChange: (Int)->() = { _ in }
    
    // convert data string into HTML as our description is coming in HTML String.
    
    func getDataFromString(_ atIndex: Int) {
        
//        print("\(self.tag), \(atIndex) OUTSIDE QUEUE")
        
        FlickrTableCell.disGroup.enter()
        
        DispatchQueue.global(qos: .utility)
            .async(group:FlickrTableCell.disGroup) { [unowned self] in
                let dataString = self.allItems?[atIndex].des ?? ""
                
                // We use tuple here to get extact value.. as, some times values were changing before.
                
                let (attributeStr, tagValue) = updateStringToHTML(dataString, tag: self.tag)
                
//                print("\(self.tag), \(tagValue), INSIDE GLOBAL QUEUE")
                
                self.allItems?[tagValue].attributeStrings = attributeStr
        }
        
        FlickrTableCell.disGroup.leave()
        
        FlickrTableCell.disGroup.notify(queue: DispatchQueue.main) {
            self.onSizeChange(self.tag)
        }
    }

    
    
}

