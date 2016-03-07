//
//  Post.swift
//  Instapost
//
//  Created by Douglas on 3/6/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class Post: NSObject {
    /**
     * Other methods
     */
     
     /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        let newImage = self.resize(image!, newSize: CGSize(width: 300, height: 500))//want to resize to 10MB (Max of Parse upload)
        post["media"] = getPFFileFromImage(newImage) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["name"] = PFUser.currentUser()?.username!
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    class func postUserProfile(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let username = PFUser.currentUser()?.username!
        let post = PFObject(className: "Profile")
        post["name"] = username
        let newImage = resize(image!, newSize: CGSize(width:80, height:100))
        post["avatar"] = getPFFileFromImage(newImage)
        print("In posting user profile")
        post.saveInBackgroundWithBlock(completion)

    }
    
    
    
    
    /**
     Method to resize the size of images to fit the 10MB limit of parse
     
     - parameter image: Image that the user wants to resize
     
        size: Desired size (width, height) of  image
     - returns: The new image
     
     */
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

}
