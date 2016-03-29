//
//  ParseData.swift
//  Instapost
//
//  Created by Douglas on 3/28/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse

class ParseUserData: NSObject {
    /*class var sharedInstance: ParseData{
        struct Static{
            static let instance : ParseData = ParseData()
        }
        return Static.instance
    }*/
    
    static let sharedInstance: ParseUserData = ParseUserData()
    
    var name: String?
    var avatar: UIImage?
    var birthdate: String?
    var email: String?
    
    
    
    
    override init(){
        super.init()
    }
    
    func populateData(){
        name = PFUser.currentUser()?.username
        if let avatarImg = PFUser.currentUser()?.valueForKey("avatar") as? PFFile{
            avatarImg.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil{
                    let image = UIImage(data: imageData!)
                    self.avatar = image
                }else{
                    print(error)
                }
            })
        }
        
        if let dobValue = PFUser.currentUser()?.valueForKey("birthdate") as? String{
            birthdate = dobValue
        }
        if let userEmail = PFUser.currentUser()?.email{
            email = userEmail
        }
        
    }
    
    /* Change any of the field and push to parse server */
    func zhi_updateProfile(){
        print("Beep")
        let user = PFUser.currentUser()!
        print("BOOP")
        if let avatar = avatar{
            let imageData: NSData = UIImageJPEGRepresentation(avatar, 1.0)!
            let imageFile: PFFile = PFFile(name:"image.jpg", data:imageData)!
            imageFile.saveInBackgroundWithBlock(){(success: Bool, error: NSError?)-> Void in
                if success{
                    //let user = PFUser.currentUser()
                    user.setObject(imageFile, forKey: "avatar")
                    print("Potato")
                    user.saveInBackgroundWithBlock(){(success: Bool, error:NSError?)->Void in
                        if success{
                            print("Saved")
                            user.saveInBackgroundWithBlock { (success: Bool?, error: NSError?) -> Void in
                                if (success != nil){
                                    print("Profile updated")
                                    NSNotificationCenter.defaultCenter().postNotificationName("FinishedLoadingNotification", object: self, userInfo: nil)
                                }
                            }
                        }else{
                            print(error)
                        }
                        
                    }
                }else{
                    print(error)
                }
            }
        }  
    }

    /* Getter Methods */
    func zhi_getUsername()->String?{
        return name
    }
    
    func zhi_getAvatar()->UIImage?{
        return avatar
    }
    
    func zhi_getEmail()->String?{
        return email
    }
    func zhi_getDOB()->String?{
        return birthdate
    }
    /* Setters */
    func zhi_setAvatar(image: UIImage){
        avatar = image
    }
    
    
}
