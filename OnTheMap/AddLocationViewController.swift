//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ranjith on 9/10/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class AddLocationViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var activityOutlet: UIActivityIndicatorView!
    @IBOutlet weak var dimOutlet: UIView!
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var findOnTheMap: UIButton!
    @IBOutlet weak var myMiniMapView: MKMapView!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var myMediaUrl: UITextField!
    @IBOutlet weak var questionText: UITextView!



override func viewDidLoad() {
    super.viewDidLoad()
    
   // myMiniMapView.delegate = self
    //myMiniMapView.hidden = true
    textLocation.hidden = false
   // myMediaUrl.hidden = true
    //submitOutlet.hidden = true
    questionText.text = "Where are you studying today?"
    questionText.textAlignment = .Center
    //dimOutlet.hidden = true
    //self.hideKeyboardWhenTappedAround()
}

override func viewWillAppear(animated: Bool) {
    
    //dimOutlet.hidden = true
    //subscribeToKeyboardNotifications()
   // self.unsubscribeToKeyboardNotifications()
}

override func viewWillDisappear(animated: Bool) {
    
   // self.unsubscribeToKeyboardNotifications()
}




    
//    func addKeyboardDismissRecognizer() {
//        self.view.addGestureRecognizer(tapRecognizer!)
//    }
//    
//    func removeKeyboardDismissRecognizer() {
//        self.view.removeGestureRecognizer(tapRecognizer!)
//    }
    
    }

