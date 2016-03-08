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
    @IBOutlet var avatar: UIImageView!
    
    
    
    var commentsCount: Int?
    var likesCount: Int?
    
    
    /*var object: PFObject?{
        didSet{
            print("HM?")
            //setAvatarImage.loadAvatar(object!, toSetImage: avatar)
            singleData = filteredData(object: object!)
            singleData.cell = self //give it this cell to return image to
        }
    }*/
    
    
    
    
    
    /* set singleData once, then set it again inside filtered */
    var singleData: SortedData!{
        didSet{
            print("SINGLE DATA GOT SET %%%%%%%%%%")
            userLabel.text = singleData.name
            print(singleData.name)
            snapshot.image = singleData.image
            captionLabel.text = singleData.caption!
            print(singleData.caption!)
            print(singleData.caption)
            print(captionLabel.text)
            likesCount = singleData.likesCount
            commentsCount = singleData.commentsCount
            likesLabel.text = String(likesCount!)
            commentsLabel.text = String(commentsCount!)
            snapshot.image = singleData.image
            avatar.image = singleData.avatarImg
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
    
    var profileObject: PFObject?{
        didSet{
            //setAvatarImage.loadAvatar(profileObject!, toSetImage: avatar)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Potato test")
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingAvatar:", name: "SetCellAvatarNotification", object: nil)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingAvatar(notification: NSNotification){
        print("setting avatar fired")
        let userInfo = notification.userInfo!["Profile"] as! [PFObject]
        if(userInfo.count > 0){
            profileObject = userInfo[0]
        }
    }
    
 

    
}
