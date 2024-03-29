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
    
    static func generateKeys() -> (SecKey?, SecKey?) {
        
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
    
    
    static func generarLlaves() -> (String, String) {
        
        let path = Bundle.main.path(forResource: "prime_number", ofType: "json")
        let file = try? String.init(contentsOfFile: path!)
        
        let jsonData = try! JSON.init(parseJSON: file!)
        
        
        
        let randomP = String(Int.random(in: 100000...149999))
        let randomQ = String(Int.random(in: 100000...149999))
        
        
        let p = jsonData[randomP].intValue
        let q = jsonData[randomQ].intValue
        
        let n = p * q
        
        print("p = \(p) q = \(q)")
        
        
        let e = selectE(p: p, q: q) // Calcula E
        
        let d = determineD(e: e, p: p, q: q)
        
        
        // Lave publica e,n
        // Llave privada d,n
        
        let llavePublica = "\(e)%mod%\(n)"
        
        let llavePrivada = "\(d)%mod%\(n)"
        
        
        let publicKey = llavePublica.data(using: .utf8)!.base64EncodedString()
        let privateKey = llavePrivada.data(using: .utf8)!.base64EncodedString()
 
        print("Public in base64 \(publicKey)")
        print("Private in base64 \(privateKey)")
        
        RSA.savePrivateKey(key: privateKey)
        RSA.savePublicKey(key: publicKey)
        

        return (publicKey,privateKey)

    }
    
    static func savePrivateKey(key: String) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(key, forKey: "private_key")

      
        
    }
    
    static func savePublicKey(key: String) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(key, forKey: "public_key")
        
        
        
    }
    
    static func getPrivateKey() -> String? {
       return UserDefaults.standard.string(forKey: "private_key")
    }
    
    static func getPublicKey() -> String? {
        return UserDefaults.standard.string(forKey: "public_key")
    }

    static func encriptar(mensaje: String, e: Int, n: Int) -> String? {
        
        let  bytes: [UInt8] = Array(mensaje.utf8)
        
        print("Bytes before encrypting = \(bytes)")
        
        var encryptedBytes = [String]()
        
        for b in bytes {
            let m = Int(b)
            
            let cipher = (m ^ e) % n
            encryptedBytes.append(String(cipher))
            
        }
        
        print("Encrypted bytes == \(encryptedBytes)")
        
//        var strBytes = ""
//
//        for val in bytes {
//            strBytes = strBytes + "\(val)"
//        }
//
//        let msgInt = Int(strBytes)
//
//        let encrypted = msgInt! ^ e % n
//
        
     //   String(encrypted)
        
        
        return encryptedBytes.joined().data(using: .utf8)!.base64EncodedString()
    }
    
    static func desEncriptar(base64Cipher: String, d: Int, n: Int) -> String? {
        
        let decodedData = Data(base64Encoded: base64Cipher)
        let decodedString = String(data: decodedData!, encoding: .utf8)
        print("Decoded String = \(decodedString) y  count = \(decodedString?.count)")
        
        
        var i = 0
        var decodedStringArray = [String]()
        var str = ""
        
        decodedString!.forEach {
            char in
            
            if i % 7 == 0 && i != 0 {
                
               
                decodedStringArray.append(str)
                str = String(char)

            } else if i == decodedString!.count - 1 {
                str.append(char)
                 decodedStringArray.append(str)
                
            }else {
                 str.append(char)
            }

            i += 1
        }

      
        
       
        // Convertir a UInt8
        
        var plainText: [String] = [String]()
        
        for v in decodedStringArray { //Desencriptar
            
            let c = Int(v)
            
            let plain = (c! ^ d) % n
            
            plainText.append(String(plain))
            
          
        }
        
        print("plainText = \(plainText)")
        
      
//       let plainTextStr = String(bytes: plainText, encoding: .utf8)
//
//        print("Desencripted bytes = \(plainText)")
        
       
        return nil
    }
    
    
    
    static func encriptarRSA(mensaje: String, llavePublica: String) -> String? {

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

    static func encrypt(string: String, pubKey: SecKey) -> String? {

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
            if gcd(r, n) == 1 {
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
        var m = (p - 1) * (q - 1)
        var m0 = m
        var y = 0
        var x = 1
        
        var e = e
//
        if (m == 1) {
            return 0
        }
        
        while e > 1 {
            var q = Int(e / m)
            var t = m
            m = e % m
            e = t
            t = y
            y = x - q * y
            x = t
        }
        if x < 0 {
            x = x + m0
        }
        return x
    }
}
