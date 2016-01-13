//
//  OTMConvience.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

extension OTMClient {
    
    // MARK: - Udactity API
    
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
    
    // MARK: - Parsi API
    
    func getStudentLocations(completionHandler: (error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                completionHandler(error: error)
                return
            }
            guard let data = data else {
                completionHandler(error: error)
                return
            }
            do {
                let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let results = parsedResult[OTMClient.ParseKeys.results] as? NSArray {
                    self.studentInformations.removeAll()
                    for result in results {
                        if let dictionary = result as? NSDictionary {
                            self.studentInformations.append(StudentInformation(dictionary))
                        }
                    }
                }
                completionHandler(error: nil)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandler(error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
            }
        }
        task.resume()
    }
    
    func postStudentLocation(completionHandler: (error: NSError?) -> Void) {
        let method = ParseAPI.baseURL + ParseMethods.studentLocations
        let headers = [
            "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr": "X-Parse-Application-Id",
            "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY": "X-Parse-REST-API-Key",
        ]
        let parameters: [String: AnyObject] = [
            "uniqueKey": OTMClient.sharedInstance().otmSession.account.key,
            "firstName": OTMClient.sharedInstance().user.firstName,
            "lastName": OTMClient.sharedInstance().user.lastName,
            "mapString": OTMClient.sharedInstance().studentInformation.mapString!,
            "mediaURL": OTMClient.sharedInstance().studentInformation.mediaURL!,
            "latitude": OTMClient.sharedInstance().studentInformation.latitude!,
            "longitude": OTMClient.sharedInstance().studentInformation.longitude!
        ]
        OTMClient.sharedInstance().taskForPOSTMethod(method, headers: headers, parameters: parameters, removeExtraCharacters: false) { (result, error) -> Void in
            completionHandler(error: error)
        }
    }
    
}