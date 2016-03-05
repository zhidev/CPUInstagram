//
//  LoginViewController.swift
//  Instapost
//
//  Created by Douglas on 3/4/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {
    @IBOutlet var userTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    
    var existingLoginOnStartup: Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if(existingLoginOnStartup){
            manualBypass()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userTextfield.text!, password: passwordTextfield.text!){
            (user: PFUser?, error: NSError?)-> Void in
            if user != nil{
                print("you're logged in")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }//end completion block
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = userTextfield.text
        newUser.password = passwordTextfield.text
        
        newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?)-> Void in
            if success{
                print("Created a user")
                self.performSegueWithIdentifier("loginSegue", sender: self)

            }//end if success
            else{
                if error?.code == 202{
                    print("Username is taken")
                }else{
                    print(error?.localizedDescription)
            
                }
            }
        })
    }
    
    func manualBypass(){
        if PFUser.currentUser() != nil{
            existingLoginOnStartup = false
            self.performSegueWithIdentifier("loginSegue", sender: self)
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let vc = story.instantiateViewControllerWithIdentifier("MainVC") as! MainViewController
            
            //let vc = story.instantiateViewControllerWithIdentifier("MainNav") as! UINavigationController
            //presentViewController(main, animated: true, completion: nil)
        }
    
    }
    
    
    
    
}
