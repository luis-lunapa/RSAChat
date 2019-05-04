//
//  RSA.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import Security
import UIKit

final class RSA {
    
    /**
     Generates a key pair for the RSA, both keys are stored in the system keychain and the public key should be posted
     
     - Author:
     Luis Gerardo Luna
     
     - Parameters:
        - tag: The email of the user will be used for generating the keys
     
     - Returns:
     (SecKey?, SecKey?)
     
     - Version:
     1.0
     
     - Copyright: Copyright © 2019 DeepTech.
     */
    
    static func generateKeys(tag: String) -> (SecKey?, SecKey?) {
        
        let keyTag = "com.deepTech.SecureChat".data(using: .utf8)!
        let attributes: [String: Any] =
            [
            kSecAttrKeyType as String       :  kSecAttrKeyTypeRSA, // Is for RSA
            kSecAttrKeySizeInBits as String :  2048, // Size for RSA key
            kSecPrivateKeyAttrs as String   :
                [
                    kSecAttrIsPermanent as String   : true,
                    kSecAttrApplicationTag as String: keyTag
                ]
        ]
        
        var error: Unmanaged<CFError>?
        
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print(error!.takeRetainedValue())
            return (nil, nil)
        }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)
        
        return(privateKey, publicKey)
        
        
        
    }
    
    
    static func generarLlaves() -> (Int, Int) {
        
        let path = Bundle.main.path(forResource: "prime_number", ofType: "json")
        let file = try? String.init(contentsOfFile: path!)
        
        let jsonData = try! JSON.init(parseJSON: file!)
        
        print("Json === \(jsonData)")
        
        let randomP = String(Int.random(in: 100000...149999))
        let randomQ = String(Int.random(in: 100000...149999))
        
        
        let p = jsonData[randomP].intValue
        let q = jsonData[randomQ].intValue
        
        
        
        
        
        
        return (p,q)
        
        
        
        
        
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
    
    static private func selectE(p: Int, q: Int) -> Int{
        //Select e: gcd(e,160)=1; choose e=7
        //Determine d: de≡1 mod 160 and d < 160 Value is d=23 since 23x7=161= 1x160+1
    
        let n = (p - 1) * (q - 1)
        var r = p < q ? Int.random(in: p...q) : Int.random(in: q...p)
        while true {
            if gcd(r: r, n: n) == 1 {
                break
            }else{
                r = r + 1
            }
        }
        return r        //r es la e
    }
    
    static private func gcd(_ m: Int, _ n: Int) -> Int{
        var a: Int = 0
        var b: Int = max(m, n)
        var r: Int = min(m, n)
        
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }
    
    static private func determineD(e: Int, p: Int, q: Int) -> Int {
        let n = (p - 1) * (q - 1)
        
    }
}
