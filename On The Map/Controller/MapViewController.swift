//
//  MapViewController.swift
//  On The Map
//
//  Created by Richard Trevivian on 10/20/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentLocations = [StudentInformation]()
    var selectedAnnotation: MKAnnotationView!
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigation()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        load()
    }
    
    // MARK: - Map view
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        selectedAnnotation = view
        selectedAnnotation.canShowCallout = true
        print(selectedAnnotation.canShowCallout)
        view.addGestureRecognizer(tapGesture)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        selectedAnnotation = nil
        view.removeGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func load() {
        setEnabled(false)
        OTMStudents.getStudentLocations { (error) -> Void in
            self.setEnabled(true)
            guard error == nil else {
                self.presentSimpleAlert(error!.localizedDescription, message: OTMClient.ErrorMessages.tryAgain)
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                for i in self.studentLocations {
                    self.mapView.removeAnnotation(i.annotation)
                }
                self.studentLocations = OTMStudents.studentInformations
                for b in self.studentLocations {
                    self.mapView.addAnnotation(b.annotation)
                }
            })
        }
    }
    
    func tap(sender: UITapGestureRecognizer) {
        if let view = sender.view as? MKPinAnnotationView {
            if let annotation = view.annotation {
                if let subtitle = annotation.subtitle {
                    openURL(subtitle!)
                }
            }
        }
    }
    
    func setEnabled(enabled: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
            self.activityIndicator.hidden = enabled
            self.mapView.alpha = enabled ? 1 : 0.5
        }
    }

}
