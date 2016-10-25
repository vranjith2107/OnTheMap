//
//  ONMAPClient.swift
//  OnTheMap
//
//  Created by Ranjith on 8/29/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//
import UIKit
import Foundation

class ONMAPClient: NSObject {
    
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    var nu: Int = 10
    //MARK: GET
    func taskForGETMethod(StudentType:ONMAPClient.StudentsDetails,completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
       
        
        /* 2/3. Build the URL, Configure the request */
        var request = NSMutableURLRequest()
        if StudentType == ONMAPClient.StudentsDetails.CurrentStudent{
            let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(ONMAPClient.ONMAPParameterKeys.keyValue)%22%7D"
            let url = NSURL(string: urlString)
            request = NSMutableURLRequest(URL: url!)
        }else{
            
            
            let urlValueString = "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100"
            let url = NSURL(string: urlValueString)
            request = NSMutableURLRequest(URL: url!)
        //request = NSMutableURLRequest(URL: tmdbURLFromParameters(StudentType))
        }
        request.addValue(ONMAPClient.Parse.Parse_Application_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ONMAPClient.Parse.REST_API_Key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
           // print(data);
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    
    
    
    
    // MARK: POST
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        
        /* 2/3. Build the URL, Configure the request */
        let authorizationURL = NSURL(string: "\(ONMAPClient.Constants.AuthorizationURL)")
        let request = NSMutableURLRequest(URL: authorizationURL!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
               // sendError("Your request returned a status code other than 2xx!")
               // let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "Network Failed", code: 0, userInfo: nil))

                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
          //  print(NSString(data: data, encoding: NSUTF8StringEncoding))
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForPUTMethod(jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mainurlString:String
        if let objectId = ONMAPClient.ONMAPParameterKeys.objectId {
            mainurlString = ONMAPClient.Constants.Method + "/\(objectId)"
        }else{
        mainurlString = ONMAPClient.Constants.Method }
        let url = NSURL(string: mainurlString)
        
        let request = NSMutableURLRequest(URL: url!)
        
        if let objectId = ONMAPClient.ONMAPParameterKeys.objectId {
            request.HTTPMethod = "PUT"
        }else{
            request.HTTPMethod = "POST"
        }
        request.addValue(ONMAPClient.Parse.Parse_Application_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ONMAPClient.Parse.REST_API_Key, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    

    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // create a URL from parameters
    private func tmdbURLFromParameters(StudentType:ONMAPClient.StudentsDetails) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ONMAPClient.Constants.ApiScheme
        components.host = ONMAPClient.Constants.ApiHost
        components.path = ONMAPClient.Constants.ApiPath
        if StudentType == ONMAPClient.StudentsDetails.CurrentStudent{
            //components.path = components.path! + "?where=%7B%22uniqueKey%22%3A%22\(8383019325)%22%7D"
            let dateQuery = NSURLQueryItem(name: "uniqueKey", value: "8383019325")
//            let conceptQuery = NSURLQueryItem(name: "concept_tags", value: "false")
//            let hdQuery = NSURLQueryItem(name: "hd", value: "false")
//            let apiKeyQuery = NSURLQueryItem(name: "api_key", value: API_KEY)
            components.queryItems = [dateQuery]
        }
        print(components.path)
        //let url = NSURL(string: components.path)
        return components.URL!
    }
    
    
    
    
    func taskForUSERINFOMethod(completionHandlerForUSERINFO: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + String(ONMAPClient.ONMAPParameterKeys.keyValue))!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    print("looking good")
                }
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForUSERINFO)
        }
        task.resume()
        return task
    }
    
    func taskForDeleteSession(completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    print("looking good")
                }
            }
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
            //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        return task
    }


    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ONMAPClient {
        struct Singleton {
            static var sharedInstance = ONMAPClient()
        }
        return Singleton.sharedInstance
    }


}
