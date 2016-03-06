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
    @IBOutlet var testButton: UIButton!
    
    var imageOrig: UIImage!
    
    var vc: UIImagePickerController?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        vc = UIImagePickerController()
        vc!.delegate = self
        vc!.allowsEditing = true

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
    
    
    @IBAction func postPhoto(sender: AnyObject) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate //should be able to comment it out
        loadingNotification.labelText = "Posting image please wait..."
        Post.postUserImage(imageOrig, withCaption: captionText.text){ (success: Bool, error: NSError?)-> Void in
            if success{
                print("Success: (assert(true)) : \(success)")
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                self.finishPost()
            }else{
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: false)
        }//end closure
    }
    
    @IBAction func testTab(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
        print("Test")
    }
    
    
    func finishPost(){
        self.tabBarController?.selectedIndex = 0
        //switch to main view controller
    }
    
    
}
