//
//  User.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class User: Object {
    
    dynamic var idUser: String = ""
    dynamic var token: String = ""
    dynamic var email: String = ""
    dynamic var name: String = ""
    dynamic var privateKey: String? = ""
    @objc private dynamic var profilePicData: Data?
    
    dynamic var messagesSent = [Message]()
    
    
    
    convenience init (idUser: String, token: String, email: String, name: String, profilePic: String?) {
        self.init()
        self.idUser         = idUser
        self.token          = token
        self.email          = email
        self.name           = name
        //self.profilePicData = profilePic
        
    }
    
    func getProfileImage() -> UIImage? {
        if let p = self.profilePicData {
            if let image = UIImage(data: p) {
                return image
            } else {
                return nil
            }
        }
        return nil
    }
    
    func getMessage(idMessage: String) -> Message? {
        
        for m in self.messagesSent {
            if m.idMessage == idMessage {
                return m
            }
            
        }
        return nil
        
    }
    
    func getProfileImageData() -> Data? {
        return self.profilePicData
    }
    
    func getProfileImageString() -> String? {
        if let p = self.profilePicData {
            if let imageString = p.base64EncodedString(options: []) as String? {
                return imageString
            } else {
                return nil
            }
        }
        return nil
    }
    
    func save() {
        if let realm = AppManager.shared.persistencia.realmBD() {
            if realm.objects(User.self).count != 0 {
                try! realm.write {
                    realm.deleteAll()
                }
            }
            try! realm.write {
                realm.add(self)
            }
        }
    }
    
    
    
}
