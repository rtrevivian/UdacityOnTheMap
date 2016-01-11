//
//  OTMSession.swift
//  On The Map
//
//  Created by Richard Trevivian on 1/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

struct OTMSession {
    
    var account: Account!
    var session: Session!
    
    init(_ data: NSDictionary) {
        
        if let account = data[OTMClient.UdacityKeys.account] as? NSDictionary {
            self.account = Account(account)
        }
        if let session = data[OTMClient.UdacityKeys.session] as? NSDictionary {
            self.session = Session(session)
        }
        
    }
    
}