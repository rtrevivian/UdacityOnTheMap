//
//  OTMConvience.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func getSession(username: String, password: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let method = UdacityAPI.baseUrl + UdacityMethods.session
        let headers = [String: String]()
        let parameters = [UdacityParameters.udacity : [UdacityParameters.username: username, UdacityParameters.password: password]]
        OTMClient.sharedInstance().taskForPOSTMethod(method, headers: headers, parameters: parameters, removeExtraCharacters: true) { (result, error) -> Void in
            if let dictionary = result as? NSDictionary {
                OTMClient.sharedInstance().otmSession = OTMSession(dictionary)
            }
            completionHandler(result: result, error: error)
        }
    }
    
    func deleteSession(completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityAPI.baseUrl + UdacityMethods.session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie?
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let cookies = sharedCookieStorage.cookies  {
            for cookie in cookies {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(result: nil, error: error)
                    return
                }
                guard let data = data else {
                    completionHandler(result: nil, error: error)
                    return
                }
                OTMClient.parseJSONWithCompletionHandler(OTMClient.removeLastCharacters(data), completionHandler: completionHandler)
            }
            task.resume()
        }
    }
    
    func getUser(completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let method = UdacityAPI.baseUrl + UdacityMethods.users + "/" + OTMClient.sharedInstance().otmSession.account.key
        OTMClient.sharedInstance().taskForGETMethod(method, parameters: nil, removeExtraCharacters: true) { (result, error) -> Void in
            if let dictionary = result as? NSDictionary {
                if let user = dictionary[OTMClient.UdacityKeys.user] as? NSDictionary {
                    OTMClient.sharedInstance().user = User(user)
                }
                completionHandler(result: result, error: error)
            }
        }
    }
    
}