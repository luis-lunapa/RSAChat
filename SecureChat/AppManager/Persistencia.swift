//
//  Persistencia.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import RealmSwift


class Persistencia {
    
    private var realm: Realm?
    
    var currentUser: User?
    
    
    func realmBD() -> Realm? {
        if AppManager.shared.persistencia.realm == nil {
            print("Realm es nil, se creara ahora...")
            
            
            let config = Realm.Configuration(
                encryptionKey: getKey() as Data,
                schemaVersion: 3,
                migrationBlock: { migration, oldSchemaVersion in
                    
                    if oldSchemaVersion < 3 {
                        print("Actualizando Schema !!!!")
                        
                    }
                    
            }
                
            )
            
            
            do {
                AppManager.shared.persistencia.realm = try Realm(configuration: config)
                
            } catch  {
                print("Ocurrio un error: \(error)")
            }
            
        } else {
            //print("Ya existe realm")
        }
        return AppManager.shared.persistencia.realm
    }
    
    private func getKey() -> NSData {
        print("Obteniendo llave realm")
        // Identificador para el llavero unico
        let keychainIdentifier = "com.deepTech.SecureChat"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // Verificar si la entrada ya existe en el llavero
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        //Obtener el objeto del llavero usando unsafeMutablePointer para mejorar el performance
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            print("LLave en llavero")
            return dataTypeRef as! NSData
        }
        
        // No existe llave en el llavero asi que se genera una nueva
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Error al obtener bytes aleatorios")
        
        // Se guarda esta llave en el llavero
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Error al insertar nueva llave en el llavero.")
        print("llave agregada a llavero")
        return keyData
        
        
    }
    
    
}
