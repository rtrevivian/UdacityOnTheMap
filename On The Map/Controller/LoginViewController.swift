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
                    
                    setEnabled(false)
                    
                    OTMClient.sharedInstance().getSession(username, password: password) { (result, error) -> Void in
                        self.setEnabled(true)
                        guard error == nil else {
                            self.presentSimpleAlert(error!.localizedDescription, message: OTMClient.ErrorMessages.tryAgain)
                            return
                        }
                        if let _ = result[OTMClient.UdacityKeys.status] as? Int {
                            if let message = result[OTMClient.UdacityKeys.error] as? String {
                                self.presentSimpleAlert("Login failed", message: message)
                            }
                        } else {
                            OTMClient.sharedInstance().getUser({ (result, error) -> Void in
                                guard error == nil else {
                                    self.presentSimpleAlert(error!.localizedDescription, message: OTMClient.ErrorMessages.tryAgain)
                                    return
                                }
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.usernameText.text = ""
                                    self.passwordText.text = ""
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
    
    func setEnabled(enabled: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.usernameText.enabled = enabled
            self.passwordText.enabled = enabled
            self.loginButton.enabled = enabled
            self.loginButton.alpha = enabled ? 1 : 0.5
        }
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        openURL("https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw")
    }

}
