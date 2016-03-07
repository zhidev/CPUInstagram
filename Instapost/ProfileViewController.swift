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

    
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var createProfileButton: UIButton!
    @IBOutlet var updateProfileButton: UIButton!
    
    
    var avatarImg: UIImage?
    var profile: PFObject?
    var vc: UIImagePickerController?
    
    
    var doesProfileExists: Bool?{
        didSet{
            print("TESTERINO EXISTERINO")
            if doesProfileExists!{
                createProfileButton.backgroundColor = UIColor.grayColor()
                createProfileButton.enabled = false
                updateProfileButton.backgroundColor = UIColor.blackColor()
                updateProfileButton.enabled = true
            }else{
                createProfileButton.backgroundColor = UIColor.blackColor()
                createProfileButton.enabled = true
                updateProfileButton.backgroundColor = UIColor.grayColor()
                updateProfileButton.enabled = false
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileButton.backgroundColor = UIColor.grayColor()
        createProfileButton.enabled = false
        updateProfileButton.backgroundColor = UIColor.grayColor()
        updateProfileButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let username = PFUser.currentUser()?.username!
        userLabel.text = username
        vc = UIImagePickerController()
        vc!.delegate = self
        vc!.allowsEditing = true
        vc!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        profileExists(username!)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        if PFUser.currentUser() == nil{
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
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
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
        }

    }
    
    @IBAction func updateProfile(sender: AnyObject) {
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            avatarImg = originalImage
            avatar.image = editedImage
            //self.setter?.imageFrame?.image = originalImage
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }

    func profileExists(username: String){
        var exists = false
        
        let query = PFQuery(className: "Profile")
        query.whereKey("name", equalTo: username)
        query.findObjectsInBackgroundWithBlock{ (results: [PFObject]?, error: NSError?)->Void in
            if error == nil{
                print(results)
                if(results!.count > 1){
                    print("More than 1 profile exists for this user...???")
                }
                else if( results!.count == 1){
                    exists = true //profile does exist
                    self.loadAvatar(results![0])//unwrap our shoul.d be only PFObject
                    self.doesProfileExists = exists
                    
                }else{
                    exists = false //profile doesnt exist
                    self.doesProfileExists = exists
                }
            }else{
                print("Error:\(error)")
            }
        }
    }

    func loadAvatar(object: PFObject){
        print("Starting loadAvatar")
        if let avatar = object.valueForKey("avatar")! as? PFFile{
            avatar.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?)->Void in
                if((error == nil)){
                    let image = UIImage(data:imageData!)
                    self.avatar.image = image
                }
                print("Finish stuff")
            })//end block
        }//end if let avatar
    }//end func
    
}
