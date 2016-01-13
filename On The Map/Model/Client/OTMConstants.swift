//
//  OTMConstants.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

extension OTMClient {
    
    struct UdacityAPI {
    
        static let baseUrl = "https://www.udacity.com/api/"
        static let facebookAppID = "365362206864879"
        static let facebookUrlSuffix = "365362206864879"
        
    }
    
    struct UdacityMethods {
        
        static let session = "session"
        static let users = "users"
        
    }
    
    struct UdacityParameters {
        
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        
    }
    
    struct UdacityKeys {
        
        static let account = "account"
        static let error = "error"
        static let expiration = "expiration"
        static let first_name = "first_name"
        static let id = "id"
        static let key = "key"
        static let last_name = "last_name"
        static let registered = "registered"
        static let status = "status"
        static let session = "session"
        static let user = "user"
        
    }
    
    struct ParseAPI {
        
        static let baseURL = "https://api.parse.com/1/classes/"
        
    }
    
    struct ParseMethods {
        
        static let studentLocations = "StudentLocation"

    }
    
    struct ParseParameters {
        
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        
    }
    
    struct ParseKeys {
        
        static let results = "results"
        
    }
    
    struct ErrorMessages {
        static let tryAgain = "Please check your internet connection and try again"
    }
    
}