//
//  User.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/10/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String!
    var lastName: String!
    
    init(_ data: NSDictionary) {
        
        firstName = data[OTMClient.UdacityKeys.first_name] as? String
        lastName = data[OTMClient.UdacityKeys.last_name] as? String
        
    }
    
}