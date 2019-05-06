//
//  Friend.swift
//  SecureChat
//
//  Created by Luis Luna on 5/5/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation

class Friend {
    
    let name: String
    let email: String
    let public_key_base64: String
    let public_key: String
    let e: Int
    let n: Int
    
    
    init(name: String, email: String, public_key: String) {
        
        self.name       = name
        self.email      = email
        self.public_key_base64 = public_key
        self.public_key = String.init(data: Data.init(base64Encoded: public_key)!, encoding: .utf8)!
        
        let publicArray = self.public_key.components(separatedBy: "%mod%")
        
        self.e = Int(publicArray[0])!
        self.n = Int(publicArray[1])!
        
        
        
    }
    
    
}
