//
//  ONMAPStudent.swift
//  OnTheMap
//
//  Created by Ranjith on 9/2/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation

// MARK: - STUDENT

struct ONMAPStudent {
    
    // MARK: Properties
    let createdAt:String
    let firstName:String
    let lastName:String
    let latitude:Double
    let longitude:Double
    let mapString:String
    let mediaURL:String?
    let objectId:String
    let uniqueKey:String
    let updatedAt:String
    
    
    // MARK: Initializers
    
    // construct a ONMAPStudent from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        if let createdAtvalue = dictionary[ONMAPClient.JSONResponseKeys.CreatedAt]{
            createdAt = createdAtvalue as! String
        }
        else{
            createdAt = ""
        }
        if let firstNamevalue = dictionary[ONMAPClient.JSONResponseKeys.FirstName]{
            firstName = firstNamevalue as! String
        }
        else{
            firstName = ""
        }
        if let lastNamevalue = dictionary[ONMAPClient.JSONResponseKeys.LastName]{
            lastName = lastNamevalue as! String
        }
        else{
            lastName = ""
        }
        if let latitudevalue = dictionary[ONMAPClient.JSONResponseKeys.Latitude]{
            latitude = latitudevalue as! Double
        }
        else{
            latitude = 0.0
        }
        if let longitudevalue = dictionary[ONMAPClient.JSONResponseKeys.Longitude]{
            longitude = longitudevalue as! Double
        }
        else{
            longitude = 0.0
        }
        if let mapStringvalue = dictionary[ONMAPClient.JSONResponseKeys.CreatedAt]{
            mapString = mapStringvalue as! String
        }
        else{
            mapString = ""
        }
        if let mediaURLvalue = dictionary[ONMAPClient.JSONResponseKeys.MediaURL]{
            mediaURL = mediaURLvalue as! String
        }
        else{
            mediaURL = ""
        }
        if let objectIdvalue = dictionary[ONMAPClient.JSONResponseKeys.ObjectId]{
            objectId = objectIdvalue as! String
        }
        else{
            objectId = ""
        }
        if let uniqueKeyvalue = dictionary[ONMAPClient.JSONResponseKeys.UniqueKey]{
            uniqueKey = uniqueKeyvalue as! String
        }
        else{
            uniqueKey = ""
        }
        if let updatedAtvalue = dictionary[ONMAPClient.JSONResponseKeys.UpdatedAt]{
            updatedAt = updatedAtvalue as! String
        }
        else{
            updatedAt = ""
        }
        
       // lastName = dictionary[ONMAPClient.JSONResponseKeys.LastName] as! String
        //latitude = dictionary[ONMAPClient.JSONResponseKeys.Latitude] as! Double
       // longitude = dictionary[ONMAPClient.JSONResponseKeys.Longitude] as! Double
       // mapString = dictionary[ONMAPClient.JSONResponseKeys.MapString] as! String
       // mediaURL = dictionary[ONMAPClient.JSONResponseKeys.MediaURL] as! String
       // objectId = dictionary[ONMAPClient.JSONResponseKeys.ObjectId] as! String
        //uniqueKey = dictionary[ONMAPClient.JSONResponseKeys.UniqueKey] as! String
        //updatedAt = dictionary[ONMAPClient.JSONResponseKeys.UpdatedAt] as! String
        
    }
    
    static func studentFromResults(results: [[String:AnyObject]]) -> [ONMAPStudent] {
        
        var students = [ONMAPStudent]()
        
        // iterate through array of dictionaries, each student is a dictionary
        for result in results {
            print(result[ONMAPClient.JSONResponseKeys.FirstName])
            students.append(ONMAPStudent(dictionary: result))
            
        }
        
        return students
    }

    
}
