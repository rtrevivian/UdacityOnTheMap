//
//  Session.swift
//  On The Map
//
//  Created by Richard Trevivian on 12/4/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import Foundation

struct Session {
    
    var id: String!
    var expiration: String!
    
    init(_ data: NSDictionary) {
        
        id = data[OTMClient.UdacityKeys.id] as? String
        expiration = data[OTMClient.UdacityKeys.expiration] as? String
        
    }
    
}
