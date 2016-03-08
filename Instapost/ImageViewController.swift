//
//  ImageViewController.swift
//  Instapost
//
//  Created by Douglas on 3/5/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var snapshot: UIImageView!
    @IBOutlet var captionText: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var takeButton: UIButton!
    @IBOutlet var postButton: UIButton!
    
    var imageOrig: UIImage!
    
    var vc: UIImagePickerController?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = UIImagePickerController()
        vc!.delegate = self
        vc!.allowsEditing = true
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotProfileToSend:", name: "SetProfilePostNotification", object: nil)
        
        
        
    }

    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Do something with the images (based on your use case)
            snapshot.image = editedImage
            imageOrig = originalImage

            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func searchPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            vc!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc!, animated: true, completion: nil)
        }else{
            print("photo library not available")
        }
        print("TestsearchPhoto")
    }
    
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            vc!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(vc!, animated: true, completion: nil)
        }else{
            print("camera not available")
        }
        print("TesttakePhoto")
    }
    
    /* Chain Link #1 AAA */
    @IBAction func postPhoto(sender: AnyObject) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate //should be able to comment it out
        loadingNotification.labelText = "Posting image please wait..."
        //grabProfile()
        sendPhoto()
    }
    /*
    /* Chain Link #2 AAA */
    func grabProfile(){
        setAvatarImage.loadProfile((PFUser.currentUser()?.username!)!, specialCase: "Post")
    }
    
    /* Chain Link #3 AAA */
    func gotProfileToSend(notfication: NSNotification){
        var profile: PFObject?
        let userInfo = notfication.userInfo!["Profile"] as! [PFObject]
        if(userInfo.count>1){
            profile = userInfo[0]
        }else{
            profile = PFObject(className: "Profile")
        }
        sendPhoto()//(profile)
    }*/
    

    /* Chain Link #4 AAA */

    func sendPhoto(){//(profile: PFObject?){

        Post.postUserImage(imageOrig, withCaption: captionText.text){ (success: Bool, error: NSError?)-> Void in
            if success{
                print("Success: (assert(true)) : \(success)")
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                self.finishPost()
            }else{
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: false) //finally close HUD from Chain Link #1 AAA
        }//end closure
    }
    
    func finishPost(){
        self.tabBarController?.selectedIndex = 0
        self.captionText.text = "Add a caption..."
        self.captionText.resignFirstResponder()
        //switch to main view controller
    }
}
