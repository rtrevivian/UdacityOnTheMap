//
//  StudentLocation.swift
//  On The Map
//
//  Created by Richard Trevivian on 12/8/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentInformation: NSObject, MKAnnotation {
    
    var title: String? {
        return firstName
    }
    
    var subtitle: String? {
        return mediaURL
    }
    
    var coordinate: CLLocationCoordinate2D
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    var latitude: Double?
    var longitude: Double?
    
    init(_ data: NSDictionary) {
        
        createdAt = data[StudentInformationKeys.createdAt] as? String
        firstName = data[StudentInformationKeys.firstName] as? String
        lastName = data[StudentInformationKeys.lastName] as? String
        mapString = data[StudentInformationKeys.mapString] as? String
        mediaURL = data[StudentInformationKeys.mediaURL] as? String
        objectId = data[StudentInformationKeys.objectId] as? String
        uniqueKey = data[StudentInformationKeys.uniqueKey] as? String
        updatedAt = data[StudentInformationKeys.updatedAt] as? String
        
        
        latitude = data[StudentInformationKeys.latitude] as? Double
        longitude = data[StudentInformationKeys.longitude] as? Double
        coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        super.init()
        
    }
    
}
