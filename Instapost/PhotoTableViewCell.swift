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

    /* set singleData once, then set it again inside filtered */
    var singleData: SortedData!{
        didSet{
            if let sd_name = singleData.name{
                userLabel.text = sd_name
            }
            if let sd_image = singleData.image{
                snapshot.image = sd_image
            }
            if let sd_caption = singleData.caption{
                captionLabel.text = sd_caption
            }
            if let sd_likes_count = singleData.likesCount{
                likesCount = sd_likes_count
                likesLabel.text = String(likesCount!)

            }
            if let sd_comments_count = singleData.commentsCount{
                commentsCount = sd_comments_count
                commentsLabel.text = String(commentsCount!)
            }
            if let sd_avatar = singleData.avatarImg{
                avatar.image = sd_avatar
            }
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

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
