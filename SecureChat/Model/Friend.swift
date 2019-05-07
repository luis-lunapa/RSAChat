//
//  Friend.swift
//  SecureChat
//
//  Created by Luis Luna on 5/5/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import Security

class Friend {
    
    let name: String
    let email: String
    let public_key_base64: String
    
//    let public_key: String?
//    let e: Int?
//    let n: Int?
//
    var publicK: SecKey?
    
    
    init(name: String, email: String, public_key: String) {
        
        self.name       = name
        self.email      = email
        self.public_key_base64 = public_key

        
        
    }
    
    
    
    
    
    func getSecPublicKey () {
        if let data2 = Data.init(base64Encoded: public_key_base64){
            let keyDict:[NSObject:NSObject] = [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits: NSNumber(value: 512),
                kSecReturnPersistentRef: true as NSObject
            ]
 
            
            self.publicK = SecKeyCreateWithData(data2 as CFData, keyDict as CFDictionary, nil)
            print("P KEY ++ \(publicK)")
        }
        
        
    }
}
