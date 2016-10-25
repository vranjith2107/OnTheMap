//
//  LocationViewController.swift
//  On The Map
//
//  Created by Michael Nienaber on 23/05/2016.
//  Copyright © 2016 Michael Nienaber. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import SystemConfiguration

class LocationViewController: UIViewController, UITextViewDelegate, MKMapViewDelegate {
    
    //var myStudentLocation: [StudentLocation] = [StudentLocation]()
  /*  let mapView = MapViewController()
    var annotations = [MKPointAnnotation]()
    
    
    @IBOutlet weak var activityOutlet: UIActivityIndicatorView!
    @IBOutlet weak var dimOutlet: UIView!
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var findOnTheMap: UIButton!
    @IBOutlet weak var myMiniMapView: MKMapView!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var myMediaUrl: UITextField!
    @IBOutlet weak var questionText: UITextView!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 3.0, regionRadius * 1.0)
        
        performUIUpdatesOnMain{
        self.myMiniMapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMiniMapView.delegate = self
        myMiniMapView.hidden = true
        textLocation.hidden = false
        myMediaUrl.hidden = true
        submitOutlet.hidden = true
        questionText.text = "Where are you studying today?"
        questionText.textAlignment = .Center
        dimOutlet.hidden = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        
        dimOutlet.hidden = true
        self.subscribeToKeyboardNotifications()
        self.unsubscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        
        activityOutlet.startAnimating()
        dimOutlet.hidden = false
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.textLocation.text!
        request.region = myMiniMapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, error in
            
            self.activityOutlet.stopAnimating()
            self.dimOutlet.hidden = true
            
            if let error = error {
                
                let failSearchAlert = UIAlertController(title: "Oops!", message: "Either you have a problem with your connection or your query returned zero results", preferredStyle: UIAlertControllerStyle.Alert)
                failSearchAlert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { alertAction in self.returnToMapView() }))
                self.presentViewController(failSearchAlert, animated: true, completion: nil)
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
            } else {
                
                self.textLocation.hidden = true
                self.myMiniMapView.hidden = false
                self.questionText.text! = "What's your media URL"
                self.questionText.textAlignment = .Center
                self.findOnTheMap.hidden = true
                self.submitOutlet.hidden = false
                self.myMediaUrl.hidden = false
                self.dismissAnyVisibleKeyboards()
                
               
                performUIUpdatesOnMain {
                    
                    for item in response!.mapItems {
                        
                        let annotation = MKPointAnnotation()
                        let lat = item.placemark.coordinate.latitude
                        let long = item.placemark.coordinate.longitude
                        let title = item.placemark.title
                        let initialLocation = CLLocation(latitude: lat, longitude: long)
                        
                        self.centerMapOnLocation(initialLocation)
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        annotation.coordinate = coordinate
                        annotation.title = title
                        self.annotations.append(annotation)
                        ONMAPClient.ONMAPParameterKeys.latitude = lat
                        ONMAPClient.ONMAPParameterKeys.longitude = long
                        ONMAPClient.ONMAPParameterKeys.mapString = title
                        
                        
                    }
                    self.myMiniMapView.addAnnotations(self.annotations)
                
                }

            }
            
                    }
    }
    
    
    func getPostToMap(jsonBody: String) {
        

        if Reachability.isConnectedToNetwork() {
        ONMAPClient.sharedInstance().postToMap(jsonBody) { (result, error) in
            
            if error != nil {
                
                self.dimOutlet.hidden = true
                self.activityOutlet.stopAnimating()
                print(error)

                
            } else {
                
                self.dimOutlet.hidden = true
                self.activityOutlet.stopAnimating()
                print("success")
                self.returnToMapView()
            }
        }
    }
    else{

            let failLoginAlert = UIAlertController(title: "Failed to download", message: "Please check your Network and try again", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) {
                                UIAlertAction in
                self.dimOutlet.hidden = true
                self.activityOutlet.stopAnimating()
                            }
            failLoginAlert.addAction(okAction)
            self.presentViewController(failLoginAlert, animated: true, completion: nil)
    }
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        
       returnToMapView()
    }
    
    func returnToMapView() {

        ONMAPClient.sharedInstance().getStudentDetails { (results, error) in

            if error != nil {

                print("that's an error")
                self.dimOutlet.hidden = true
                self.activityOutlet.stopAnimating()
                self.dismissViewControllerAnimated(true, completion: nil)

            } else {

                performUIUpdatesOnMain {

                    print("refresh is \(results)")
                    self.dimOutlet.hidden = true
                    self.activityOutlet.stopAnimating()
                    self.dismissViewControllerAnimated(true, completion: nil)

                }
            }
        }
    }
    
    
    @IBAction func submitButton(sender: AnyObject) {
        
        dimOutlet.hidden = false
        activityOutlet.startAnimating()

        let submitableURL = self.myMediaUrl.text!
        
        let jsonBody: String = "{\"uniqueKey\": \"\(ONMAPClient.ONMAPParameterKeys.keyValue)\", \"firstName\": \"\(ONMAPClient.ONMAPParameterKeys.firstName!)\", \"lastName\": \"\(ONMAPClient.ONMAPParameterKeys.lastName!)\",\"mapString\": \"\(ONMAPClient.ONMAPParameterKeys.mapString!)\", \"mediaURL\": \"\(submitableURL)\",\"latitude\": \(ONMAPClient.ONMAPParameterKeys.latitude!), \"longitude\": \(ONMAPClient.ONMAPParameterKeys.longitude!)}"
        
        print(jsonBody)
       self.getPostToMap(jsonBody)
    }
    
    func failPost() {
        
        let failPostAlert = UIAlertController(title: "Yikes", message: "There seems to be a problem, your post didn't execute!", preferredStyle: UIAlertControllerStyle.Alert)
        failPostAlert.addAction(UIAlertAction(title: "I'll try again later", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(failPostAlert, animated: true, completion: { alertAction in self.returnToMapView() })
    }*/
}

/*
extension LocationViewController {
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
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

    func dismissAnyVisibleKeyboards() {
        if textLocation.isFirstResponder() || myMediaUrl.isFirstResponder() {
            self.view.endEditing(true)
        }
    }

    
}





public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}*/