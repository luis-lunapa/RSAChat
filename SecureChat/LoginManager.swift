//
//  LoginManager.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import PromiseKit
import RealmSwift
import Alamofire
import os
class LoginManager {
    
    func login (username: String, password: String) {
        
        
    }
    
    func localLogin() -> User? {
        var user: User?
        
        
        guard let realm = AppManager.shared.persistencia.realmBD() else {
            os_log("No hay una instancia de realm", log: OSLog.reLogin, type: .info)
            
            return nil
        }
        
        performUIUpdatesOnMain {
            let listaLoca = realm.objects(User.self)
            if listaLoca.isEmpty {
                os_log("No hay ningún usuario para relogin", log: OSLog.reLogin, type: .info)
               
            } else {
               
                if let usuarioGuardado = listaLoca.first {
                    
                    user = User.init(idUser: usuarioGuardado.idUser, token: usuarioGuardado.token, email: usuarioGuardado.email, name: usuarioGuardado.name, profilePic: usuarioGuardado.getProfileImageData())
                    
                }
                
                
                
            }
            
        }
        
        return user
    }
    
    
    func isUserLoggedIn() -> Bool {
        var logged = false
        
        guard let realm = AppManager.shared.persistencia.realmBD() else {
            os_log("No hay una instancia de realm", log: OSLog.reLogin, type: .info)
            logged = false
            return logged
        }
        
        performUIUpdatesOnMain {
            let listaLoca = realm.objects(User.self)
            if listaLoca.isEmpty {
                os_log("No hay ningún usuario para relogin", log: OSLog.reLogin, type: .info)
                logged = false
            } else {
                logged = true
            }
            
        }

       return logged
    }
    
    
    
    
    
}
