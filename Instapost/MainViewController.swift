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
    
    
    var data: [PFObject]?
    let HeaderViewIdentifier = "TableViewHeader"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("testing, viewDidLoad()")
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)

        
        getData()
        tableView.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell
        if data != nil{
            print("Test")
            let object = data![indexPath.row]
            print("%%%%%%%%%%%%%%%%%%")
            print(object.createdAt)
            print("$$$$$$$$$$$$$$$$")
            cell.createdString = calculateTimestamp(object.createdAt!.timeIntervalSinceNow)
            cell.object = object
        }
        let patternNumber = (indexPath.row % 5)
        cell.colorOrder = patternNumber
        print("Test3")
        print(data)
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
                print("**********************")
                print(posts)
                self.data = posts
                self.tableView.reloadData()
                print("$$$$$$$$$$$$$$$$$$$$$$$$")
            }else{
                print("ERROR: Couldn't obtain data from parse.")
                print(error)
            }
        
        
        }//end query
        print("endGetData")
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
    
    
    
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        print("PIKACHU:")
        print(data?[0])
        return header
    }*/
    
}
