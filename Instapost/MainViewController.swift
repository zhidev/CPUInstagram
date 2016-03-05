//
//  MainViewController.swift
//  Instapost
//
//  Created by Douglas on 3/5/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    @IBOutlet var logoutButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        if PFUser.currentUser() == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "preload")
            dismissViewControllerAnimated(true, completion: nil)
            print("Logged out")
        }
    }
    

}
