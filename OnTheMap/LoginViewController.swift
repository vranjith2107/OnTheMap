//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ranjith on 8/29/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurTextfield(userName)
        configurTextfield(passWordField)
        
        }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        userName.text = nil
        passWordField.text = nil
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    //MARK: Login Button Pressed
    
    @IBAction func loginPreesed(sender: AnyObject) {
        ONMAPClient.ONMAPParameterKeys.Username = userName.text!
        ONMAPClient.ONMAPParameterKeys.Password = passWordField.text!
        setUIEnabled(false)
        
        
        ONMAPClient.sharedInstance().authenticateWithViewController() { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                   self.displayError(errorString)
                }
            }
        }

        
    }
    
    
    @IBAction func dontHavePreesed(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: ONMAPClient.Constants.SignupURL)!)

    }
    
    
    private func completeLogin(){
        
        setUIEnabled(true)
        print("Success")
        var controller:UITabBarController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarcontroller") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)

        
    }
    
    private func displayError(errorString: NSError?) {
        setUIEnabled(true)
        userName.text = nil
        passWordField.text = nil
        print(errorString!)
        let alertError: UIAlertController
        
        switch errorString!.code {
        case 0: alertError = createAlertError("Login Error", message: "Wrong user name and/or password. Please try again")
        case 1: alertError = createAlertError("Network Failure", message: "We are sorry! We are not able to connect to the network")
        default: alertError = createAlertError("Sorry!", message: errorString!.localizedDescription)
        }
        self.presentViewController(alertError, animated: true, completion: nil)
//        let failLoginAlert = UIAlertController(title: "Forgotten your Username or Password?", message: "Please check your credentials with Udacity and try again later", preferredStyle: UIAlertControllerStyle.Alert)
//        failLoginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(failLoginAlert, animated: true, completion: nil)
//        failLoginAlert.addAction(UIAlertAction(title: "Go To Udacity", style: UIAlertActionStyle.Default, handler: {
//            (action:UIAlertAction!) in
//            UIApplication.sharedApplication().openURL(NSURL(string: ONMAPClient.Constants.SignupURL)!)
//        }))
    }

    func createAlertError(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    //MARK: UITextField Methods / Keyboard methods
    func configurTextfield(textfield:UITextField){
        textfield.textAlignment = .Center
        textfield.delegate = self
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: TextField Delegation Methods
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        textField.text = nil
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }

}

//MARK: Configure UI
extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        userName.enabled = enabled
        passWordField.enabled = enabled
        loginButton.enabled = enabled
        dontHaveAccountButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            dontHaveAccountButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            dontHaveAccountButton.alpha = 0.5
        }
}

}

