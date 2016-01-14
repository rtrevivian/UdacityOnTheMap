//
//  OTMClient.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class OTMClient {
    
    // MARK: Properties
    
    var otmSession: OTMSession!
    var user: User!
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject]?, removeExtraCharacters: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var urlString = method
        if let _ = parameters {
            urlString += OTMClient.escapedParameters(parameters!)
        }
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            guard let data = data else {
                completionHandler(result: nil, error: error)
                return
            }
            var newData = data
            if removeExtraCharacters {
                newData = OTMClient.removeLastCharacters(data)
            }
            OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, headers: [String: String], parameters: [String : AnyObject], removeExtraCharacters: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: method)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        for i in headers {
            request.addValue(i.0, forHTTPHeaderField: i.1)
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
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
            var newData = data
            if removeExtraCharacters {
                newData = OTMClient.removeLastCharacters(data)
            }
            OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    // MARK: Helpers
    
    /* Helper: Remove last 5 characters */
    class func removeLastCharacters(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(5, data.length - 5))
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
}