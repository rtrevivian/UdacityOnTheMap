//
//  Account.swift
//  On The Map
//
//  Created by Richard Trevivian on 12/4/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import Foundation

struct Account {
    
    var registered: Bool!
    var key: String!
    
    init(_ data: NSDictionary) {
        
        registered = data[OTMClient.UdacityKeys.registered] as? Bool
        key = data[OTMClient.UdacityKeys.key] as? String
        
    }
    
}
