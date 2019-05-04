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
        let errorMessage = "Your account could not be created, try again"
        
        return Promise {
            seal in
            
            let parameters: [String: String] = [
                
                "name"      : name,
                "email"     : email,
                "password"  : password,
                "public_key": public_key,
                
                ]
            
            Alamofire.request(APIURL.luisUrl + "creaCuenta", parameters: parameters).responseJSON {
                response in
                
                if let data = response.result.value {
                    let jsonData = JSON(data)
                    
                    let status = jsonData["status"].intValue
                    if status != 200 {
                        
                        
                        
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
    
    
    
    
    
    
    
    
}
