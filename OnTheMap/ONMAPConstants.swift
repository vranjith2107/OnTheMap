//
//  ONMAPConstants.swift
//  OnTheMap
//
//  Created by Ranjith on 8/29/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation

extension ONMAPClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "YOUR_API_KEY_HERE"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"
        static let SignupURL : String = "https://www.udacity.com/account/auth#!/signup"
        static let Method = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    // MARK: TMDB Parameter Keys
    struct ONMAPParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static var keyValue = "session_id"
        static var Username = "username"
        static var Password = "password"
        static var latitude: Double? = nil
        static var longitude: Double? = nil
        static var mediaUrl: String? = nil
        static var mapString: String? = nil
        static var firstName: String? = nil
        static var lastName: String? = nil
        static var objectId:String? = nil
    }
    
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let DomainName = "udacity"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        static let StudentResult = "results"
        
        //MARK: Auth
        static let Account = "account"
        static let Key = "key"
        static let Registered = "registered"
        
    }
    
    //MARK: PARSE
    struct Parse {
        static let Parse_Application_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let REST_API_Key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct CurrentStudent {
        var latitude: Double? = nil
        var longitude: Double? = nil
        var mediaUrl: String? = nil
        var mapString: String? = nil
        var firstName: String? = nil
        var lastName: String? = nil
    }
    
    enum StudentsDetails{
        case CurrentStudent
        case AllStudent
        
    }


}
