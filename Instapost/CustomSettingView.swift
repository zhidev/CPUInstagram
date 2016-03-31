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
    
    
    func midCoordinates(inpoint: CGPoint, inObject: AnyObject)-> CGPoint{
        //--------------------------------------------------------
        // Make sure we stay within the bounds of the parent view
        //--------------------------------------------------------
        //Taken from http://stackoverflow.com/questions/9314045/dragging-a-specific-uiimageview and translated to swift and this portion
        var returnpoint = inpoint
        
        
        let midPointX = CGRectGetMidX(inObject.bounds)
        // If too far right...
        if (returnpoint.x > inObject.superview!!.bounds.size.width  - midPointX){
            returnpoint.x = inObject.superview!!.bounds.size.width - midPointX
        }
        else if (returnpoint.x < midPointX){  // If too far left...
            returnpoint.x = midPointX
        }
        
        let midPointY = CGRectGetMidY(inObject.bounds)
        // If too far down...
        if (returnpoint.y > inObject.superview!!.bounds.size.height  - midPointY){
            returnpoint.y = inObject.superview!!.bounds.size.height - midPointY
        }
        else if (returnpoint.y < midPointY){  // If too far up...
            returnpoint.y = midPointY
        }
        
        // Set new center location
        //self.center = newPoint Moved to animate with duration
        return returnpoint
    }
    
    @IBAction func avatarPanned(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(self.contentView)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Began")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let newPoint = midCoordinates(point, inObject: avatarView)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.avatarView.center = newPoint
            })
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            print("Ended")
        }
    }
    
    
    
    
    @IBAction func usernamePanned(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(self.contentView)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Began")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let newPoint = midCoordinates(point, inObject: usernameLabel)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.usernameLabel.center = newPoint
            })
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            print("Ended")
        }
    }
    
    
    
    @IBAction func birthdatePanned(panGestureRecognizer: AnyObject) {
        let point = panGestureRecognizer.locationInView(self.contentView)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Began")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let newPoint = midCoordinates(point, inObject: birthdateLabel)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.birthdateLabel.center = newPoint
            })
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            print("Ended")
        }
    }
    
}
