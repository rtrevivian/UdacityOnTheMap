//
//  PostViewController.swift
//  On The Map
//
//  Created by Richard Trevivian on 10/20/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import MapKit
import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var findButton: UIBarButtonItem!
    var submitButton: UIBarButtonItem!
    
    var mapString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "cancel")
        
        findButton = UIBarButtonItem(title: "Find", style: .Done, target: self, action: "find")
        findButton.enabled = false
        
        submitButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submit")
        submitButton.enabled = false
        
        inputText.delegate = self
        inputText.becomeFirstResponder()
        inputText.becomeFirstResponder()
        
        activityIndicator.hidden = true
        
        editing = false
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        title = editing ? "What would you like to share?" : "Where are you studying today?"
        inputText.placeholder = editing ? "Enter a link to share here" : "Enter your location"
        navigationItem.rightBarButtonItem = editing ? submitButton : findButton
    }
    
    // MARK: - Text field
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let button = editing ? submitButton : findButton
        if string != "\n" {
            if let str = textField.text {
                button.enabled = !(str as NSString).stringByReplacingCharactersInRange(range, withString: string).isEmpty
            }
        }
        return true
    }
    
    // MARK: - Actions
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func find() {
        mapString = inputText.text
        inputText.text = ""
        findButton.enabled = false
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString, completionHandler: didCompleteGeocoding)
    }
    
    func didCompleteGeocoding(placemarks: [CLPlacemark]?, error: NSError?) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        
        guard error == nil else {
            presentSimpleAlert("Error Geocoding", message: "The supplied string could not be Geocoded")
            return
        }
        if let _ = placemarks {
            if !placemarks!.isEmpty {
                let placemark = placemarks![0]
                let geocodedLocation = placemark.location!
                centerMapOnLocation(geocodedLocation)
                
                OTMClient.sharedInstance().studentInformation = StudentInformation([
                    "firstName": OTMClient.sharedInstance().user.firstName,
                    "lastName": OTMClient.sharedInstance().user.lastName,
                    "mapString": mapString,
                    "latitude": geocodedLocation.coordinate.latitude,
                    "longitude": geocodedLocation.coordinate.longitude
                ])
                
                mapView.addAnnotation(OTMClient.sharedInstance().studentInformation)
                editing = true
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func submit() {
        submitButton.enabled = false
        OTMClient.sharedInstance().studentInformation.mediaURL = inputText.text!
        inputText.text = ""
        OTMClient.sharedInstance().postStudentLocation { (error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
