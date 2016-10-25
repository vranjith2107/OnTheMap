//
//  StudentData.swift
//  OnTheMap
//
//  Created by Ranjith on 9/29/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation


import Foundation

class StudentData {
    var studentData: [ONMAPStudent]?
    
    init() {
        
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
    
}