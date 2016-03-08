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
    
    
    var check = (check1: false, check2: false)


    
    var exit: Bool?{
        didSet{
            print("^^^^EXIT SET^^^^")
            //exit
            print(caption)
            NSNotificationCenter.defaultCenter().postNotificationName("SortedDataNotification", object: self, userInfo: ["SortedData":self])
            NSNotificationCenter.defaultCenter().postNotificationName("SortingNotification", object: self, userInfo: nil)
            
        }
    }
    var profile: PFObject?{
        didSet{
            setAvatar(profile!)
        }
    }

    override init(){
        
    }
    
    
    
    
     func parse(data: PFObject){ // copy pasta from filtered data
        print(":::::::::::::::::::INIT PARSE :::::::::::::::::::::::")
        /* Create new object */
        let newData = data
        
        /* Filter out our object */
        //author = newObject["author"] as! PFUser
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
                self.check.check2 = true
                self.checkForExit()
            })//end block
        }//end if let
        grabProfile(name!)
    }
    
    
    
    func grabProfile(username: String){ //copy pasta setAvatarImage load profile
        let query = PFQuery(className: "Profile")
        query.whereKey("name", equalTo: username)
        query.findObjectsInBackgroundWithBlock{ (results: [PFObject]?, error: NSError?)->Void in
            if error == nil{
                print(results)
                if(results!.count > 1){
                    print("More than 1 profile exists for this user...???")
                    self.profile = results![0]
                }
                else if(results!.count == 1){
                    print("expected result")
                    self.profile = results![0]

                }else{
                    print("No profile found")
                    self.check.check1 = true
                    self.checkForExit()
                    /* Skip to end for this one no profile/avatar set*/
                }

            }else{
                print("Error:\(error)")
            }
        }
        print("end loading profile")
    }
    
    func setAvatar(object: PFObject){
        /*if(object["name"] == ""){
            print("SortedData setAvatar() object[Name] is empty so profile doesnt exist thus empty avatar")
            
        }else{*/ //else everything else
            if let avatar = object.valueForKey("avatar")! as? PFFile{
                avatar.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?)->Void in
                    if(error == nil){
                        self.avatarImg = UIImage(data:imageData!)
                    }else{
                        print("error")
                    }
                self.check.check1 = true
                self.checkForExit()
                print("Finishing SortedData setAvatar() completion block)")
                })//end block
            }//end if let avatar
        //}
    }
    
    
    
    func checkForExit(){
        print("CHECKING FOR EXIT ")
        if check.check1{
            print("1111111111111111")
            if check.check2{
                print("2222222222222222")
                exit = true
            }
        }
    }
    
    
}
