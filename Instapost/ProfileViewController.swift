//
//  ProfileViewController.swift
//  Instapost
//
//  Created by Douglas on 3/6/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userSingleton = ParseUserData.sharedInstance
    
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var createProfileButton: UIButton!
    @IBOutlet var updateProfileButton: UIButton!
    @IBOutlet var birthdateLabel: UILabel!
    
    
    var avatarImg: UIImage?
    var vc: UIImagePickerController?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileButton.backgroundColor = UIColor.blackColor()
        createProfileButton.enabled = true
        createProfileButton.layer.cornerRadius = 10
        createProfileButton.clipsToBounds = true
        updateProfileButton.backgroundColor = UIColor.blackColor()
        updateProfileButton.enabled = true
        updateProfileButton.layer.cornerRadius = 10
        updateProfileButton.clipsToBounds = true
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        //®NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingProfile:", name: "SetProfileVCNotification", object: nil)
        userSingleton.populateData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endProgress:", name: "FinishedLoadingNotification", object: nil)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        /*let username = PFUser.currentUser()?.username!
        userLabel.text = username*/
        setFields()
        vc = UIImagePickerController()
        vc!.delegate = self
        vc!.allowsEditing = true
        vc!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //profileExists(username!)
        //setAvatarImage.loadProfile(username!, specialCase: "ProfileVC")
    }

    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        if PFUser.currentUser() == nil{
            userSingleton.zhi_logged_out(true)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "preload")
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            vc!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc!, animated: true, completion: nil)

        }
    }
    
    
    @IBAction func createProfile(sender: AnyObject) {
        /*let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate //should be able to comment it out
        loadingNotification.labelText = "Creating profile please wait..."
        Post.postUserProfile(avatarImg){ (success: Bool, error: NSError?)->Void in
            if error == nil{
                print("\(success): Profile created")
                self.doesProfileExists = true
                MBProgressHUD.hideHUDForView(self.view, animated: false)
            }else{
                print("Error: \(error)")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: false)
        }*/

    }
    
    @IBAction func updateProfile(sender: AnyObject) {
        print("Update Profile clicked")
        //userSingleton.zhi_setAvatar(avatar.image!)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate //should be able to comment it out
        loadingNotification.labelText = "Updating avatar please wait..."
        userSingleton.zhi_updateProfile()
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            //avatarImg = originalImage
            avatar.image = editedImage
            //self.setter?.imageFrame?.image = originalImage
            userSingleton.zhi_setAvatar(avatar.image!)
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setFields(){
        print("Setting fields")
        if let username = userSingleton.zhi_getUsername(){
            userLabel.text = username
        }
        if let avatarData = userSingleton.zhi_getAvatar(){
            avatar.image = avatarData
        }
        
        if let bday = userSingleton.zhi_getDOB(){
            birthdateLabel.text = bday
        }
        /*
        if let email = ParseUserData.sharedInstance.getEmail(){
            //set email fields here
        }*/
    }
    
    func endProgress(notification: NSNotification){
        MBProgressHUD.hideHUDForView(self.view, animated: false)
    }
    
}
