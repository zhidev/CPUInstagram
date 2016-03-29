//
//  CustomSettingView.swift
//  Instapost
//
//  Created by Douglas on 3/29/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit

class CustomSettingView: UIView {


    @IBOutlet var contentView: UIView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var birthdateLabel: UILabel!
    
    //Gestures
    @IBOutlet var contentTapGesture: UITapGestureRecognizer!
    @IBOutlet var avatarPanGesture: UIPanGestureRecognizer!
    @IBOutlet var usernamePanGesture: UIPanGestureRecognizer!
    @IBOutlet var birthdatePanGesture: UIPanGestureRecognizer!
    
    
    
    
    
    let singleton = ParseUserData.sharedInstance

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentViewMoved:", name: "CustomViewNotification", object: nil)
        let nib = UINib(nibName: "CustomSettingView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        avatarView.contentMode = UIViewContentMode.ScaleAspectFill
        avatarView.clipsToBounds = true
        addSubview(contentView)
        setData()
    }


    func setData(){
        if let image = singleton.zhi_getAvatar(){
            avatarView.image = image
        }
        if let username = singleton.zhi_getUsername(){
            usernameLabel.text = username
        }
        if let dob = singleton.zhi_getDOB(){
            birthdateLabel.text = dob
        }
    }
    
    func contentViewMoved(notification: NSNotification){
        setData()
    }
    
    
    @IBAction func avatarPanned(sender: UIPanGestureRecognizer) {
    }
    
    
    
    
    @IBAction func usernamePanned(sender: UIPanGestureRecognizer) {
    }
    
    
    
    @IBAction func birthdatePanned(sender: AnyObject) {
    }
    
}
