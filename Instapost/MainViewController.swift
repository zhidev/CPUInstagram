//
//  MainViewController.swift
//  Instapost
//
//  Created by Douglas on 3/5/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    
    
    
    var customViewWhenOpen: CGRect!
    var customViewWhenClosed: CGRect!
    var trueForOpenFalseForClosed = false
    var xtranslation: CGFloat!
    
    var customView: CustomSettingView!
    
    
    var refreshControl: UIRefreshControl!
    
    
    
    var dataCount: Int?{
        didSet{
            print("Data didSet : \(dataCount)  -------- \(data?.count) ======= \(sortedData.count)")
            if(dataCount == data?.count){
                print("Inside dataCountDidSet if loop")
                tableView.reloadData()
            }
        }
    }
    
    var counter = 0
    var data: [PFObject]?
    var sortedData = [SortedData]()
    
    
    let HeaderViewIdentifier = "TableViewHeader"
    let singleton = ParseUserData.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        singleton.populateData()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appendSortedData:", name: "SortedDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createSortedData:", name: "SortingNotification", object: nil)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        customViewWhenOpen = CGRectMake(0, 0, self.view.frame.size.width/2.5, self.view.frame.size.height)
        customViewWhenClosed = CGRectMake(-self.view.frame.size.width/2.5 + 15, 0, self.view.frame.size.width/2.5, self.view.frame.size.height)
        xtranslation = -self.view.frame.size.width/2.5 + 15
        
        customView = CustomSettingView(frame: customViewWhenClosed)
        //customView.imageContent.image = UIImage(named: "gradient")
        customView.userInteractionEnabled = true
        
        view.addSubview(customView)
        trueForOpenFalseForClosed = false
        
        
        //print(testView.frame)
        let TapGesture = UITapGestureRecognizer(target: self, action: "contentViewTapped:")
        customView.addGestureRecognizer(TapGesture)

        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        if PFUser.currentUser() == nil{
            singleton.zhi_logged_out(true)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "preload")
            dismissViewControllerAnimated(true, completion: nil)
            print("Logged out")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell
        print("SORTED DATA != nil is : \(sortedData)")
        let object = sortedData[indexPath.row]
        print("OBJECT CAPTION IS :\(object.caption)")
        cell.createdString = calculateTimestamp(object.createdAt!.timeIntervalSinceNow)
        cell.singleData = object
        let patternNumber = (indexPath.row % 5)
        cell.colorOrder = patternNumber
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data{
            print("Data count: \(data.count)")
            return data.count
        }
        return 0
    }
    
    func getData(){
        print("Start get data")
        dataCount = 0
        sortedData.removeAll()
        let query = PFQuery(className: "Post")
        /* Set query parameters */
        query.orderByDescending("createdAt")
        query.includeKey("author")
        //query.includeKey("name")
        query.limit = 20
        
        /* Fetch data asynchronously from Parse. Lines immediately called after call without waiting for return data*/
        query.findObjectsInBackgroundWithBlock{ (posts: [PFObject]?, error: NSError?)->Void in
            print("Entered Block")
            if let posts = posts{
                self.data = posts
                self.sortData()
                //self.tableView.reloadData()
            }else{
                print("ERROR: Couldn't obtain data from parse.")
                print(error)
                self.tableView.reloadData()
            }
        }//end query
        print("endGetData")
        //tableView.reloadData()
    }

    func calculateTimestamp(tweetTime: NSTimeInterval) -> String {
        //Turn tweetTime into sec, min, hr , days, yrs
        var time = Int(tweetTime)
        var timeAgo = 0
        var timeChar = ""
        
        time = time*(-1)
        
        // Find time ago
        if (time <= 60) { // SECONDS
            timeAgo = time
            timeChar = "sec"
        } else if ((time/60) <= 60) { // MINUTES
            timeAgo = time/60
            timeChar = "min"
        } else if (time/60/60 <= 24) { // HOURS
            timeAgo = time/60/60
            timeChar = "hr"
        } else if (time/60/60/24 <= 365) { // DAYS
            timeAgo = time/60/60/24
            timeChar = "day"
        } else if (time/(3153600) <= 1) { // YEARS
            timeAgo = time/60/60/24/365
            timeChar = "yr"
        }
        //format string
        return "\(timeAgo)\(timeChar) ago"
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        getData()
        refreshControl.endRefreshing()
    }

    
    func sortData(){
        counter = 0
        print("SORTING DATA: \(data!.count) & \(sortedData.count)")
        NSNotificationCenter.defaultCenter().postNotificationName("SortingNotification", object: self, userInfo: nil)
    }
    
    func createSortedData(notification: NSNotification){
        //let indice = notification.userInfo!["Counter"] as! Int
        if (counter < data?.count){
            let indice = counter
            let object = data![indice]
            let newData = SortedData()
            newData.parse(object)
            counter++
        }
    }
    
    
    func appendSortedData(notification: NSNotification){
        print("SORTED DATA COUNT :\(sortedData.count)")
        let userInfo = notification.userInfo!["SortedData"] as! SortedData
        sortedData.append(userInfo)
        print("SortedData Caption: \(userInfo.caption)")
        dataCount!++
    }
    
    func contentViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("tapped")
        UIView.animateWithDuration(1.2) { () -> Void in
            //self.testView.center = CGPoint(x: self.testView.center.x + 200, y: self.testView.center.y+300)
            if( self.trueForOpenFalseForClosed){ // currentlyOpen
                self.customView.transform = CGAffineTransformMakeTranslation(0, 0)
                //self.testView.frame = self.customViewWhenClosed
                self.trueForOpenFalseForClosed = false
            }else{ //CurrentlyClosed
                self.customView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width/2.5 - 15, 0)
                //self.testView.frame = self.customViewWhenOpen
                self.trueForOpenFalseForClosed = true
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("CustomViewNotification", object: self, userInfo: nil)
    }
    
}
