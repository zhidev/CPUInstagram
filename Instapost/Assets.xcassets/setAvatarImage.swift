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
    
    class func loadProfile(username: String, specialCase: String){//, var profileObjectToSet: PFObject?){
        //var observer = notificationCenter.add
        print("Loading profile")
        print(specialCase)
        let query = PFQuery(className: "Profile")
        query.whereKey("name", equalTo: username)
        query.findObjectsInBackgroundWithBlock{ (results: [PFObject]?, error: NSError?)->Void in
            if error == nil{
                print(results)
                if(results!.count > 1){
                    print("More than 1 profile exists for this user...???")
                }
                else if(results!.count == 1){
                    
                    //profileObjectToSet = results![0]

                    //NSNotificationCenter.defaultCenter().postNotificationName("SetProfileVCNotification", object: self, userInfo: ["Profile":results!])
                }else{
                    print("No profile found")
                    //NSNotificationCenter.defaultCenter().postNotificationName("SetProfileVCNotification", object: self, userInfo: ["Profile":results!])
                }
                if(specialCase == "ProfileVC"){
                    print("special case: cell")
                    NSNotificationCenter.defaultCenter().postNotificationName("SetProfileVCNotification", object: self, userInfo: ["Profile":results!])
                }
                if(specialCase == "Cell"){
                    print("special case: profilevc")

                    NSNotificationCenter.defaultCenter().postNotificationName("SetCellAvatarNotification", object: self, userInfo: ["Profile":results!])
                }
            }else{
                print("Error:\(error)")
            }
        }
        print("end loading profile")
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
