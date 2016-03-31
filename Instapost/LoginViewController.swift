//
//  LoginViewController.swift
//  Instapost
//
//  Created by Douglas on 3/4/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var userTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var dobPicker: UIPickerView!
    @IBOutlet var dobLabel: UILabel!
    
    var existingLoginOnStartup: Bool = false
    
    let singleton = ParseUserData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        dobPicker.delegate = self
        dobPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        existingLoginOnStartup = defaults.boolForKey("preload")
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
            }else{
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        }//end completion block
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = userTextfield.text
        newUser.password = passwordTextfield.text
        newUser.setObject(labelString, forKey: "birthdate")
        /* Create default avatar */
        let baseAvatar = UIImage(named: "no-avatar")
        let imageData: NSData = UIImageJPEGRepresentation(baseAvatar!, 1.0)!
        let imageFile: PFFile = PFFile(name: "avatarImage.jpg", data: imageData)!
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if(success){
                newUser.setObject(imageFile, forKey: "avatar")
                print("SAVED")
                newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?)-> Void in
                    print(newUser)
                    
                    if success{
                        print("Created a user")
                        print(newUser)
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                        
                    }//end if success
                    else{
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }
                })
            }
        }

    }
    
    func manualBypass(){
        if PFUser.currentUser() != nil{
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    
    }

    
    /* Picker variables */
    let monthArray = ["Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let dayArray1 = ["Day","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    let dayArray2 = ["Day","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    let dayArrayLeap = ["Day","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"]
    let dayArrayNonLeap = ["Day","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
    let yearArray = ["Year","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"]
    let dayList = ["1", "2", "3", "4"]
    
    var dayCheck = 0
    
    var leap = false
    
    var feb = false
    
    var defaultString = "Please Select Your Birthdate"
    var mutatingString: (Int, Int, Int) = (0, 0, 0)
    var labelString = "No birthdate set."
    
    
}
