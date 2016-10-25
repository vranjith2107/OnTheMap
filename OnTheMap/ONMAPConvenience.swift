//
//  ONMAPConvenience.swift
//  OnTheMap
//
//  Created by Ranjith on 9/2/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation

extension ONMAPClient{
    
    
    //MARK: Auth
    func authenticateWithViewController(completionHandlerForAuth: (success: Bool, errorString: NSError?) -> Void) {
        
        let jsonBody = "{\"\(ONMAPClient.JSONBodyKeys.DomainName)\": {\"username\":\"\(ONMAPClient.ONMAPParameterKeys.Username)\",\"password\":\"\(ONMAPClient.ONMAPParameterKeys.Password)\"}}"
        
        /* 2. Make the request */
        taskForPOSTMethod(jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForAuth(success: false, errorString: NSError(domain: "Failed", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Network failed"]))
            } else {
                
                print(results)
                if let resultsdata = results[ONMAPClient.JSONResponseKeys.Account],
                    let resultsdata2 = resultsdata![ONMAPClient.JSONResponseKeys.Key], let registered = resultsdata![ONMAPClient.JSONResponseKeys.Registered]{
                        
                        ONMAPClient.ONMAPParameterKeys.keyValue = resultsdata2! as! String
                        if registered! as! Int == 1
                        {
                            completionHandlerForAuth(success: true, errorString: nil)
                        }
                        else{
                            completionHandlerForAuth(success: false, errorString: NSError(domain: "Failed", code: 1, userInfo: [NSLocalizedDescriptionKey: "incorrect Username or Passed"]))
                        }
                }
                else{
                    completionHandlerForAuth(success: false, errorString: NSError(domain: "Failed", code: 1, userInfo: [NSLocalizedDescriptionKey: "incorrect Username or Passed"]))
                }
                
            }
            
            
        }
        
    
    }

    
    // MARK: GET Convenience Methods
    
    func getStudentDetails(completionHandlerForFavMovies: (result: [ONMAPStudent]?, error: NSError?) -> Void) {

        taskForGETMethod(ONMAPClient.StudentsDetails.AllStudent,completionHandlerForGET: { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForFavMovies(result: nil, error: error)
            } else {
                
                if let results = results[ONMAPClient.JSONResponseKeys.StudentResult] as? [[String:AnyObject]] {
                    
                    let movies = ONMAPStudent.studentFromResults(results)
                    completionHandlerForFavMovies(result: movies, error: nil)
                } else {
                    completionHandlerForFavMovies(result: nil, error: NSError(domain: "parsing error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse "]))
                }
            }
        })
    }
    
    func getCurrentStudentDetails(completionHandlerForFavMovies: (success: Bool, error: NSError?) -> Void) {
        
        /* 2. Make the request */
        taskForGETMethod(ONMAPClient.StudentsDetails.CurrentStudent,completionHandlerForGET: { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForFavMovies(success: false, error: error)
            } else {
               // print(results)
                if let results = results[ONMAPClient.JSONResponseKeys.StudentResult] as? [[String:AnyObject]] {
                    
                    for result in results {
                        print(result[ONMAPClient.JSONResponseKeys.FirstName])
                        ONMAPClient.ONMAPParameterKeys.latitude = result[ONMAPClient.JSONResponseKeys.Latitude]! as? Double
                        ONMAPClient.ONMAPParameterKeys.longitude = result[ONMAPClient.JSONResponseKeys.Longitude]! as? Double
                        ONMAPClient.ONMAPParameterKeys.firstName = result[ONMAPClient.JSONResponseKeys.FirstName]! as? String
                        ONMAPClient.ONMAPParameterKeys.lastName = result[ONMAPClient.JSONResponseKeys.LastName]! as? String
                        ONMAPClient.ONMAPParameterKeys.mapString = result[ONMAPClient.JSONResponseKeys.MapString]! as? String
                        ONMAPClient.ONMAPParameterKeys.mediaUrl = result[ONMAPClient.JSONResponseKeys.MediaURL]! as? String
                        ONMAPClient.ONMAPParameterKeys.objectId = result[ONMAPClient.JSONResponseKeys.ObjectId]! as? String
                    }
                    
                    if results.count == 0 {
                        completionHandlerForFavMovies(success: false, error: nil)
                    }else{
                        completionHandlerForFavMovies(success: true, error: nil)}

                }
                
            }
        })
    }
    
    func postToMap(jsonBody: String, completionHandlerForPOST: (result: Int?, error: NSError?) -> Void) {
        
        
        taskForPUTMethod(jsonBody) { results, error in
            
            if let error = error {
                
                completionHandlerForPOST(result: nil, error: error)
            } else {
                
                if let results = results as? Int? {
                    
                    completionHandlerForPOST(result: results, error: nil)
                } else {
                    
                    completionHandlerForPOST(result: nil, error: error)
                }
            }
        }
    }

    func getUserCompleteInfo(completionHandlerForUSERINFO: (result: AnyObject!, error: NSError?) -> Void) {
        
        
        
        taskForUSERINFOMethod() { (result, error) in
            
            if let error = error {
                
                completionHandlerForUSERINFO(result: nil, error: error)
            } else {
                
                if let result = result as? [String: AnyObject]? {
                    
                    let user = result!["user"]!
                    
                    if let lastName = user["last_name"] as? String {
                        
                        ONMAPParameterKeys.lastName = lastName
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            print("Failed to get (lastname).")
                        }
                    }
                    
                    if let firstName = user["first_name"] as? String {
                        
                        ONMAPParameterKeys.firstName = firstName
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            print("Failed to get (firstname).")
                        }
                    }
                    
                    completionHandlerForUSERINFO(result: result, error: nil)
                } else {
                    
                    completionHandlerForUSERINFO(result: nil, error: error)
                }
            }
        }
    }
    
    func deleteSession(completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) {
        
        taskForDeleteSession() { (result, error) in
            
            if let error = error {
                
                completionHandlerForDELETE(result: nil, error: error)
                
            } else {
                
                if let result = result as? [String: AnyObject]? {
                    
                    let deleteResult = result!["session"]!
                    completionHandlerForDELETE(result: deleteResult, error: nil)
                }
            }
        }
    }


    


}
