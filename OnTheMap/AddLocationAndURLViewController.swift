//
//  AddLocationAndURLViewController.swift
//  OnTheMap
//
//  Created by Ranjith vanaparthi on 10/19/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AddLocationAndURLViewController: UIViewController, UITextViewDelegate, MKMapViewDelegate  {

    @IBOutlet weak var activView: UIView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findmapButton: UIButton!
    @IBOutlet weak var mediaUrlLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var MKView: MKMapView!
    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var urlTextView: UITextField!
    var annotations = [MKPointAnnotation]()
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        MKView.delegate = self
        self.view.backgroundColor = UIColor.grayColor()
        self.subscribeToKeyboardNotifications()
        self.unsubscribeToKeyboardNotifications()
        self.activView.hidden = true
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.mediaUrlLabel.hidden = true
        self.urlTextView.hidden = true
        self.submitButton.hidden = true
        self.activView.hidden = true
        
    }
    
 

    @IBAction func findonMapPressed(sender: AnyObject) {
        
        activityindicator.startAnimating()
        self.activView.hidden = false
        self.mediaUrlLabel.hidden = false
        self.urlTextView.hidden = false
        self.submitButton.hidden = false
        self.locationLabel.hidden = true
        self.textView.hidden = true
        self.findmapButton.hidden = true
        
        let requestText = MKLocalSearchRequest()
        requestText.naturalLanguageQuery = self.textView.text!
        requestText.region = MKView.region
        
        let searchForPin = MKLocalSearch(request: requestText)
        searchForPin.startWithCompletionHandler { response, error in
            self.activityindicator.stopAnimating()
            self.activView.hidden = true
            
            
            if let error = error {
               print("error is \(error)")
                
                let failSearchAlert = UIAlertController(title: "Oops!", message: "Either you have a problem with your connection or your query returned zero results", preferredStyle: UIAlertControllerStyle.Alert)
                failSearchAlert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { alertAction in self.dismissViewControllerAnimated(true, completion: nil) }))
                self.presentViewController(failSearchAlert, animated: true, completion: nil)
                

            } else {
                

                
                performUIUpdatesOnMain {
                    self.activityindicator.stopAnimating()
                    self.activView.hidden = true
                    for itemData in response!.mapItems {
                        
                        let annotationData = MKPointAnnotation()
                        let latitude = itemData.placemark.coordinate.latitude
                        let longitude = itemData.placemark.coordinate.longitude
                        let title = itemData.placemark.title
                        let initialLocationData = CLLocation(latitude: latitude, longitude: longitude)
                        
                        let coordinateRegionData = MKCoordinateRegionMakeWithDistance(initialLocationData.coordinate,
                            1500 * 3.0, 1500 * 1.0)
                        
                        performUIUpdatesOnMain{
                            self.MKView.setRegion(coordinateRegionData, animated: true)
                        }
                        
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        annotationData.coordinate = coordinate
                        annotationData.title = title
                        self.annotations.append(annotationData)
                        ONMAPClient.ONMAPParameterKeys.latitude = latitude
                        ONMAPClient.ONMAPParameterKeys.longitude = longitude
                        ONMAPClient.ONMAPParameterKeys.mapString = title
                        
                        
                    }
                    self.MKView.addAnnotations(self.annotations)
                    
                }
                

    }
        }
   
        
}
    
    @IBAction func sumitUserPressed(sender: AnyObject) {
        
        activityindicator.startAnimating()
        self.activView.hidden = false
        
        let submitableURL = self.urlTextView.text!
        
        let jsonBody: String = "{\"uniqueKey\": \"\(ONMAPClient.ONMAPParameterKeys.keyValue)\", \"firstName\": \"\(ONMAPClient.ONMAPParameterKeys.firstName!)\", \"lastName\": \"\(ONMAPClient.ONMAPParameterKeys.lastName!)\",\"mapString\": \"\(ONMAPClient.ONMAPParameterKeys.mapString!)\", \"mediaURL\": \"\(submitableURL)\",\"latitude\": \(ONMAPClient.ONMAPParameterKeys.latitude!), \"longitude\": \(ONMAPClient.ONMAPParameterKeys.longitude!)}"
        
        print(jsonBody)
        self.SumbitToMap(jsonBody)
    }
    
    func SumbitToMap(jsonBody: String) {
        
        
        if Reachability.isConnectedToNetwork() {
            ONMAPClient.sharedInstance().postToMap(jsonBody) { (result, error) in
                
                if error != nil {
                    print(error)
                    let failLoginAlert = UIAlertController(title: "Failed to download", message: "Please check your Network and try again", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                       
                        self.activityindicator.stopAnimating()
                        self.activView.hidden = true
                    }
                    failLoginAlert.addAction(okAction)
                    self.presentViewController(failLoginAlert, animated: true, completion: nil)
                    
                } else {
                    print("success")
                    self.returnToMapViewController()
                }
            }
        }
        else{
            
            let failLogin = UIAlertController(title: "Failed", message: " check your Network and try again", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            failLogin.addAction(action)
            self.presentViewController(failLogin, animated: true, completion: nil)
        }
    }
    
    func returnToMapViewController() {
        
        activityindicator.stopAnimating()
        self.activView.hidden = true
        ONMAPClient.sharedInstance().getStudentDetails { (results, error) in
            
            self.activityindicator.stopAnimating()
            self.activView.hidden = true
            if error != nil {
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                performUIUpdatesOnMain {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
            }
        }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}