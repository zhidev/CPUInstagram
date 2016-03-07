//
//  setAvatarImage.swift
//  Instapost
//
//  Created by Douglas on 3/7/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse



class setAvatarImage: NSObject {
    
    class func loadProfile(username: String, var profileObjectToSet: PFObject?){
        
        let query = PFQuery(className: "Profile")
        query.whereKey("name", equalTo: username)
        query.findObjectsInBackgroundWithBlock{ (results: [PFObject]?, error: NSError?)->Void in
            if error == nil{
                print(results)
                if(results!.count > 1){
                    print("More than 1 profile exists for this user...???")
                }
                else if(results!.count == 1){
                    
                    profileObjectToSet = results![0]
                    print("TESTING5555")
                    print(profileObjectToSet)
                }else{
                    print("No profile found")
                }
            }else{
                print("Error:\(error)")
            }
        }
    }
    
    
    class func loadAvatar(object:PFObject, toSetImage: UIImageView){
        print("Starting loadAvatar")
        if let avatar = object.valueForKey("avatar")! as? PFFile{
            avatar.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?)->Void in
                if((error == nil)){
                    let image = UIImage(data:imageData!)
                    toSetImage.image = image
                }else{
                    print(error)
                }
                print("Finish stuff")
            })//end block
        }//end if let avatar
    }//end func
    
    
    
}
