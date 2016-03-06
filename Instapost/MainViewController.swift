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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("testing, viewDidLoad()")
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
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
            cell.object = object
        }
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

}
