//
//  Message.swift
//  SecureChat
//
//  Created by Luis Luna on 5/6/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation

class Message {
    
    var base64EncryptedString: String?
    var plainText: String?
    var sentByMe: Bool
    
    
    init (base64: String, sentByMe: Bool) {
        self.base64EncryptedString = base64
        self.sentByMe = sentByMe
    }
    
    init(plainText: String, sentByMe: Bool) {
        
        self.plainText = plainText
        self.sentByMe = sentByMe
    }
    
    /**
     Decrypts a message from its own base64 value
     
     - Author:
     Luis Gerardo Luna
     
     - Parameters:
        - d: Private key of user
        - n: RSA n value

     - Returns:
     String?
     
     - Version:
     1.0
     
     - Important:
     The function returns nil if the text could not be decrypted
     

     - Copyright: Copyright © 2019 DeepTech.
     */

    func decrypt (d: Int, n: Int) -> String? {
        
        guard let encrypted = self.base64EncryptedString else {
            print("There's no message to decrypt")
            return nil
        }
        
        
        return ""
        
        
    }
    
    /**
     Encrypts a message from its own plainText value
     
     - Author:
     Luis Gerardo Luna
     
     - Parameters:
        - e: Public key of user who the message is going to be sent
        - n: RSA n value
     
     - Returns:
        String?
     
     - Version:
     1.0
     
     - Important:
     The function returns nil if the text could not be encrypted
     
     
     - Copyright: Copyright © 2019 DeepTech.
     */
    
    func encrypt(e: Int, n: Int) -> String? {
        
        guard let plainMsg = self.plainText else {
            print("There's no message to encrypt")
            return nil
        }
        
        return ""
        
    }
    
    
    
    
}
