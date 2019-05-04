//
//  RSA.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import Security

final class RSA {
    
    static func generarPrivateKey() {
        
        
        
    }
    
    
    static func encriptar(mensaje: String, llavePublica: String) -> String? {
        
        guard let data = Data(base64Encoded: llavePublica) else {
            print("Error al convertir llave a base64")
            return nil
        }
        
        var atributos: CFDictionary {
            return
                [
                    kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue
            ] as CFDictionary
            
            
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, atributos, &error) else {
            print("Error al encriptar = \(error.debugDescription)")
            return nil
        }
        
        return encrypt(string: mensaje, pubKey: secKey)
    }
    
    static private func encrypt(string: String, pubKey: SecKey) -> String? {
        
        let buffer = [UInt8](string.utf8)
        
        var keySize = SecKeyGetBlockSize( pubKey)
        var keyBuffer = [UInt8] (repeating: 0, count: keySize)
        
        // Se genera el texto encriptado
        
        guard SecKeyEncrypt(pubKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else {return nil}
        
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
        
    }
    
    
}
