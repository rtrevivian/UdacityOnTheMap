//
//  OTMStudents.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/14/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class OTMStudents {
    
    static var studentInformation: StudentInformation!
    static var studentInformations = [StudentInformation]()
    
    class func getStudentLocations(completionHandler: (error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
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
            if let urlResponse = response as? NSHTTPURLResponse {
                guard urlResponse.statusCode != 401 else {
                     completionHandler(error: NSError(domain: "", code: urlResponse.statusCode, userInfo: nil))
                    return
                }
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
    
    class func postStudentLocation(completionHandler: (error: NSError?) -> Void) {
        let method = OTMClient.ParseAPI.baseURL + OTMClient.ParseMethods.studentLocations
        let headers = [
            "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr": "X-Parse-Application-Id",
            "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY": "X-Parse-REST-API-Key",
        ]
        let parameters: [String: AnyObject] = [
            "uniqueKey": OTMClient.sharedInstance().otmSession.account.key,
            "firstName": OTMClient.sharedInstance().user.firstName,
            "lastName": OTMClient.sharedInstance().user.lastName,
            "mapString": OTMStudents.studentInformation.mapString!,
            "mediaURL": OTMStudents.studentInformation.mediaURL!,
            "latitude": OTMStudents.studentInformation.latitude!,
            "longitude": OTMStudents.studentInformation.longitude!
        ]
        OTMClient.sharedInstance().taskForPOSTMethod(method, headers: headers, parameters: parameters, removeExtraCharacters: false) { (result, error) -> Void in
            completionHandler(error: error)
        }
    }
    
}