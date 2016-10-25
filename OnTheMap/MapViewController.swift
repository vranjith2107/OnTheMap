//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ranjith on 9/1/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
   // var students: [ONMAPStudent] = [ONMAPStudent]()
    var annotations = [MKPointAnnotation]()
    
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadMapData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadMapData()
        
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
    
    @IBAction func rereshButtonTapped(sender: AnyObject) {
        self.mapView.removeAnnotations(self.annotations)
        
        loadMapData()
    }
  private  func locationController(){
        performUIUpdatesOnMain{
            var controller:UINavigationController
            
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("nvcontroller") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }


}

extension MapViewController:MKMapViewDelegate{
    
    
    func loadMapData(){
        ONMAPClient.sharedInstance().getStudentDetails { (students, error) in
            if let students = students {
                // self.students = students
                performUIUpdatesOnMain{
                    for dictionary in students {
                        
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // This is a version of the Double type.
                        let lat = CLLocationDegrees(dictionary.latitude)
                        let long = CLLocationDegrees(dictionary.longitude)
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = dictionary.firstName
                        let last = dictionary.lastName
                        let mediaURL = dictionary.mediaURL
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        self.annotations.append(annotation)
                    }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.addAnnotations(self.annotations)
                    //self.mapView.reloadInputViews()
                }
                
                
            }
                
            else {
                print(error)
                        let failLoginAlert = UIAlertController(title: "Failed to download", message: "Please check your Network and try again", preferredStyle: UIAlertControllerStyle.Alert)
                        failLoginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(failLoginAlert, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    
    @IBAction func logOutTapped(sender: AnyObject) {
        failLogOutAlert()
        
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
    

    
}
