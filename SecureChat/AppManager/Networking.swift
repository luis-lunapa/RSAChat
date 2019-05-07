//
//  Networking.swift
//  SecureChat
//
//  Created by Luis Luna on 5/4/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import os

//MARK: - URL tanto de prueba como funcionales
struct APIURL {
    static var luisUrl: String {
        let url = "https://www.luislunapa.com/universidad/rsa/ws1/"
        return url
        
    }
}

final class Networking {
    
    
    /**
     Creates a new account for messaging
     
     - Author:
     Luis Gerardo Luna
     
     - Parameters:
        - name: Full name of the user
        - email: Email of the user
        - password: Password of the user
     
     - Returns:
     Promise <Bool>
     
     - Version:
     1.0
     
     - Copyright: Copyright © 2019 DeepTech.
     */
    
    func createAccount(name: String, email: String, password: String, public_key: String) -> Promise<Bool> {
        var errorMessage = "Your account could not be created, try again"
        
        return Promise {
            seal in
            
            let parameters: [String: String] = [
                
                "name"      : name,
                "email"     : email,
                "password"  : password,
                "public_key": public_key,
                
                ]
            
            Alamofire.request(APIURL.luisUrl + "creaCuenta.php", parameters: parameters).responseJSON {
                response in
                
                if let data = response.result.value {
                    let jsonData = JSON(data)
                    print("Resultado == \(jsonData)")
                    let status = jsonData["status"].intValue
                    if status != 200 {
                        
                        if status == 701 {
                            errorMessage = "The email address is already registered"
                        }
  
                        os_log("createAccount: Status no fue el esperado = %{PRIVATE}@ mensaje = %{PRIVATE}@",
                               log: OSLog.registro, type: OSLogType.error,
                               String(describing: status),
                               String(describing: jsonData["msg"].stringValue))
                        
                        seal.reject(NSError(domain: "createAccount", code: 0, userInfo: ["msg": errorMessage]))
    
                    }
                    seal.fulfill(true)
                    
                    
                } else {
                    os_log("createAccount: Error al crear cuenta public_key = %{PRIVATE}@  email = %{PRIVATE}@ error = %{PRIVATE}@",
                           log: OSLog.playback, type: OSLogType.error,
                           String(describing: public_key),
                           String(describing: email),
                           String(describing: response.error))
                    seal.reject(NSError(domain: "buscarEventos", code: 0, userInfo: ["msg": errorMessage]))
                }
                
            }
            
        }
    }
    
    func login(email: String, password: String) -> Promise<User> {
        
        let errorMessage = "Our server can not authenticate your account right now, try again"
        
        return Promise {
            seal in
            
            let parameters: [String: String] = [
                
                "email"     : email,
                "password"  : password,
                
                ]
            
            Alamofire.request(APIURL.luisUrl + "login.php", parameters: parameters).responseJSON {
                response in
                
                if let data = response.result.value {
                    let jsonData = JSON(data)
                    print("Resultado == \(jsonData)")
                    
                    let status = jsonData["status"].intValue
                    if status != 200 {
                        
                        os_log("login: Status no fue el esperado = %{PRIVATE}@ mensaje = %{PRIVATE}@",
                               log: OSLog.login, type: OSLogType.error,
                               String(describing: status),
                               String(describing: jsonData["msg"].stringValue))
                        
                        seal.reject(NSError(domain: "login", code: 0, userInfo: ["msg": errorMessage]))
                        
                    }
                    
                    let idUser = jsonData["data"]["idUser"].stringValue
                    let token = jsonData["data"]["token"].stringValue
                    let email = jsonData["data"]["email"].stringValue
                    let name = jsonData["data"]["name"].stringValue
                    let profilePic = jsonData["data"]["profilePic"].string
                    
                    let usuario = User.init(idUser: idUser, token: token, email: email, name: name, profilePic: profilePic)
                    
                    
                    seal.fulfill(usuario)
                    
                    
                } else {
                    os_log("login: Error al login email = %{PRIVATE}@  error = %{PRIVATE}@",
                           log: OSLog.login, type: OSLogType.error,
                           String(describing: email),
                           String(describing: response.error))
                    seal.reject(NSError(domain: "login", code: 0, userInfo: ["msg": errorMessage]))
                }
                
            }
            
            
            
        }

    }
    
    func getAllUsers() -> Promise<[Friend]> {
        var errorMessage = "Could not get all friends list"
        
        var friends = [Friend]()
        
        return Promise {
            seal in
            
            guard let user = AppManager.shared.persistencia.currentUser else {
                seal.reject(NSError(domain: "getAllUsers", code: 0, userInfo: ["msg": "Invalid login"]))
                return 
            }
            
            let parameters: [String: String] = [
                
                "token"     : user.token,
                "idUser"    : user.idUser
                
                ]
            
            Alamofire.request(APIURL.luisUrl + "getAllUsers.php", parameters: parameters).responseJSON {
                response in
                
                if let data = response.result.value {
                    let jsonData = JSON(data)
                    print("Resultado == \(jsonData)")
                    
                    let status = jsonData["status"].intValue
                    if status != 200 {
                        
                        os_log("getAllUsers: Status no fue el esperado = %{PRIVATE}@ mensaje = %{PRIVATE}@",
                               log: OSLog.login, type: OSLogType.error,
                               String(describing: status),
                               String(describing: jsonData["msg"].stringValue))
                        
                        seal.reject(NSError(domain: "getAllUsers", code: 0, userInfo: ["msg": errorMessage]))
                        
                    }
                    
                    let jsonFriends = jsonData["data"].arrayValue
                    
                    for f in jsonFriends {
                        
                        let name = f["name"].stringValue
                        let email = f["email"].stringValue
                        let public_key = f["public_key"].stringValue
                        
                        
                        let friend = Friend.init(name: name, email: email, public_key: public_key)
                      
                        friends.append(friend)
                    }
                    
                    
                    seal.fulfill(friends)
                    
                    
                } else {
                    os_log("createAccount: Error al login error = %{PRIVATE}@",
                           log: OSLog.playback, type: OSLogType.error,
                           String(describing: response.error))
                    seal.reject(NSError(domain: "buscarEventos", code: 0, userInfo: ["msg": errorMessage]))
                }
                
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
