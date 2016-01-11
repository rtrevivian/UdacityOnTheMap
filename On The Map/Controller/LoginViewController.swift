//
//  LoginViewController.swift
//  On The Map
//
//  Created by Richard Trevivian on 10/20/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    // MARK: - Actions

    @IBAction func loginButton(sender: UIButton) {
        if var username = usernameText.text {
            if username.isEmpty {
               presentSimpleAlert("Email required", message: "Please enter your email address")
            } else if var password = passwordText.text {
                if password.isEmpty {
                     presentSimpleAlert("Password required", message: "Please enter your password")
                } else {
                    username = usernameText.text!
                    password = passwordText.text!
                    
                    usernameText.resignFirstResponder()
                    passwordText.resignFirstResponder()
                    
                    OTMClient.sharedInstance().getSession(username, password: password) { (result, error) -> Void in
                        guard error == nil else {
                            self.presentSimpleAlert("Server error", message: "Please try again later")
                            return
                        }
                        if let _ = result[OTMClient.UdacityKeys.status] as? Int {
                            if let message = result[OTMClient.UdacityKeys.error] as? String {
                                self.presentSimpleAlert("Login failed", message: message)
                            }
                        } else {
                            self.usernameText.text = ""
                            self.passwordText.text = ""
                            
                            OTMClient.sharedInstance().getUser({ (result, error) -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("rootTabBarController") {
                                        self.presentViewController(controller, animated: true, completion: nil)
                                    }
                                })
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        openURL("https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw")
    }

}
