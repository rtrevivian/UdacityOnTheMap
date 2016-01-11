//
//  ViewController.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/7/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addNavigation() {
        navigationItem.title = "On The Map"
        
        let postButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "newPost")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "load")
        navigationItem.rightBarButtonItems = [refreshButton, postButton]
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    func getFlexibleButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }
    
    func openURL(str: String) {
        var httpStr = str as NSString
        if httpStr.length >= 4 {
            if httpStr.substringToIndex(4) != "http" {
                httpStr = "http://" + str
            }
        }
        if httpStr.length >= 7 {
            if let url = NSURL(string: httpStr as String) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        } else {
            presentSimpleAlert("Invalid URL", message: str)
        }
        
    }
    
    func presentSimpleAlert(title:String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func newPost() {
        if let controller = storyboard?.instantiateViewControllerWithIdentifier("postNavigationController") {
            presentViewController(controller, animated: true, completion: { () -> Void in
            })
        }
    }
    
    func logout() {
        OTMClient.sharedInstance().deleteSession { (result, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
}
