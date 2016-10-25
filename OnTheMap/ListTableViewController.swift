//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Ranjith on 9/1/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: Properties
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the logout button
        // parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: #selector(logout))
            }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ONMAPClient.sharedInstance().getStudentDetails { (students, error) in
            if let students = students {
                StudentData.sharedInstance().studentData = students
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
       let student = StudentData.sharedInstance().studentData![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.imageView!.image = UIImage(named:"pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let stu = StudentData.sharedInstance().studentData{
            return stu.count
        }
        else
        {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentData.sharedInstance().studentData![indexPath.row]
        //UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
        let app = UIApplication.sharedApplication()
        if let toOpen = student.mediaURL {
            app.openURL(NSURL(string: toOpen)!)
        }
        
        
    }
    
    @IBAction func logOutTapped(sender: AnyObject) {
        failLogOutAlert()
        
    }
    
    @IBAction func refreshTapped(sender: AnyObject) {
        
        ONMAPClient.sharedInstance().getStudentDetails { (students, error) in
            if let students = students {
                StudentData.sharedInstance().studentData = students
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print(error)
                let failLoginAlert = UIAlertController(title: "Failed to download", message: "Please check your Network and try again", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                failLoginAlert.addAction(okAction)
                self.presentViewController(failLoginAlert, animated: true, completion: nil)
            }
        }

    }

    func logOut() {
        
        ONMAPClient.sharedInstance().deleteSession() { (result, error) in
            
            if error != nil {
                
                self.failAlertGeneral("LogOut Unsuccessful", message: "Something went wrong, please try again", actionTitle: "OK")
            } else {
                
                performUIUpdatesOnMain {
                    
                    print("logout success \(result)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }
        }
        
    }

    func failLogOutAlert() {
        
        let failLogoutAlert = UIAlertController(title: "Wanna Logout?", message: "Just double checking, we'll miss you!", preferredStyle: UIAlertControllerStyle.Alert)
        failLogoutAlert.addAction(UIAlertAction(title: "Log Me Out", style: UIAlertActionStyle.Default, handler: { alertAction in self.logOut() }))
        failLogoutAlert.addAction(UIAlertAction(title: "Take Me Back!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(failLogoutAlert, animated: true, completion: nil)
    }
    
    func failAlertGeneral(title: String, message: String, actionTitle: String) {
        
        let failAlertGeneral = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        failAlertGeneral.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(failAlertGeneral, animated: true, completion: nil)
    }
    
    private  func locationController(){
        performUIUpdatesOnMain{
            var controller:UINavigationController
            
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("nvcontroller") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pinAddButtonPressed(sender: AnyObject) {
        
        ONMAPClient.sharedInstance().getCurrentStudentDetails { (exist, error) in
            
            if exist {
                print("data exist")
                performUIUpdatesOnMain{
                    let postAlert = UIAlertController(title: "Exist", message: " pin already exist due u want overwrite", preferredStyle: UIAlertControllerStyle.Alert)
                    postAlert.addAction(UIAlertAction(title: "Update", style: .Default, handler: { (action: UIAlertAction!) in
                        self.locationController()
                    }))
                    postAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                    }))
                    self.presentViewController(postAlert, animated: true, completion: nil)
                }
                
            }
            else{
                print("not exist")
                ONMAPClient.sharedInstance().getUserCompleteInfo() { (result, error) in
                    
                    if error != nil {
                    } else {
                        
                        print("success")
                        self.locationController()
                        
                    }
                }
                
            }
            
        }
        
        
    }

    

}
