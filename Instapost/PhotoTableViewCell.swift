//
//  PhotoTableViewCell.swift
//  Instapost
//
//  Created by Douglas on 3/6/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class PhotoTableViewCell: UITableViewCell {
    
    
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var snapshot: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var createdDate: UILabel!
    
    
    
    var commentsCount: Int?
    var likesCount: Int?
    
    
    var object: PFObject?{
        didSet{
            print("HM?")
            singleData = filteredData(object: object!)
            singleData.cell = self //give it this cell to return image to
        }
    }
    
    
    
    
    
    /* set singleData once, then set it again inside filtered */
    var singleData: filteredData!{
        didSet{
            userLabel.text = singleData.name
            snapshot.image = singleData.image
            captionLabel.text = singleData.caption
            likesCount = singleData.likesCount
            commentsCount = singleData.commentsCount
            likesLabel.text = String(likesCount!)
            commentsLabel.text = String(commentsCount!)
        }
    }
    
    var createdString: String?{
    /* String for date */
        didSet{
            createdDate.text = createdString!
        }
    }
    
    let colors = [UIColor.blackColor(), UIColor.purpleColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.grayColor()]
    var colorOrder: Int?{
        didSet{
            self.backgroundColor = colors[self.colorOrder!]
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
