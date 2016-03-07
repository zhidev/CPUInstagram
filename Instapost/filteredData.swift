//
//  filteredData.swift
//  Instapost
//
//  Created by Douglas on 3/6/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class filteredData: NSObject {
    var image: UIImage?
    var author: PFUser?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var name: String?
    
    /* cell is to set image after grabbing image from block and setting*/
    var cell: PhotoTableViewCell?
    
    
    init(object: PFObject){
        super.init()
        print("INIT")
        /* Create new object */
        let newObject = object
        
        /* Filter out our object */
        //author = newObject["author"] as! PFUser
        //Not using author yet no point unwrapping
        
        caption = newObject["caption"] as? String
        likesCount = newObject["likesCount"] as? Int
        commentsCount = newObject["commentsCount"] as? Int
        name = newObject["name"] as? String
        
        if let newImage = object.valueForKey("media")! as? PFFile{
            print("^Potato^")
            newImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error:NSError?)->Void in
                print("Fish")
                if error == nil{
                    let image = UIImage(data: imageData!)
                    self.image = image
                    self.cell?.singleData = self
                    print(image)
                    print("Potato")
                }else{
                    print("Error: couldnt get image: \(error?.localizedDescription)")
                    print(error)
                }
            print("Starting to end block")
            })//end block
            print("block ended")
        }//end if let
        
        
    }
    
}
