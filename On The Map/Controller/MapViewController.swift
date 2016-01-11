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
        view.addGestureRecognizer(tapGesture)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        selectedAnnotation = nil
        view.removeGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func load() {
        OTMClient.sharedInstance().getStudentLocations { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.removeAnnotations(self.studentLocations)
                self.studentLocations = OTMClient.sharedInstance().studentInformations
                self.mapView.addAnnotations(self.studentLocations)
            })
        }
    }
    
    func tap(sender: UITapGestureRecognizer) {
        if let annotation = sender.view as? MKPinAnnotationView {
            if let studentLocation = annotation.annotation as? StudentInformation {
                openURL(studentLocation.mediaURL!)
            }
        }
    }

}
