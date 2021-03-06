//
//  SortedData.swift
//  Instapost
//
//  Created by Douglas on 3/7/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class SortedData: NSObject {
    
    
    var name: String?
    var image: UIImage?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var author: PFUser?
    var createdAt: NSDate?
    
    
    /* Profile Information*/
    var avatarImg: UIImage?
    
    

    
    var exit: Bool?{
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("SortedDataNotification", object: self, userInfo: ["SortedData":self])
            NSNotificationCenter.defaultCenter().postNotificationName("SortingNotification", object: self, userInfo: nil)
            
        }
    }

    override init(){
        
    }
    
    
    
    
     func parse(data: PFObject){ // copy pasta from filtered data
        print(":::::::::::::::::::INIT PARSE :::::::::::::::::::::::")
        /* Create new object */
        let newData = data
        
        /* Filter out our object */
        author = newData["author"] as? PFUser
        //Not using author yet no point unwrapping
        
        self.caption = newData["caption"] as? String
        self.likesCount = newData["likesCount"] as? Int
        self.commentsCount = newData["commentsCount"] as? Int
        self.name = newData["name"] as? String
        self.createdAt = data.createdAt
        
        
        if let newImage = newData.valueForKey("media")! as? PFFile{
            newImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error:NSError?)->Void in
                if error == nil{
                    let image = UIImage(data: imageData!)
                    self.image = image
                    //self.cell?.singleData = self
                }else{
                    print("Error: couldnt get image: \(error?.localizedDescription)")
                    print(error)
                }

            })//end block
        }//end if let
        
        self.author = newData["author"] as? PFUser
        print("abcd")
        if let authorAvatar = self.author?.valueForKey("avatar") as? PFFile{
            authorAvatar.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                print("Potato Fish ABCD")
                if error == nil{
                    let image = UIImage(data: imageData!)
                    self.avatarImg = image
                }else{
                    print(error)
                }
                self.exit = true

            })
        }else{
            exit = true
        }
    
    }
}
