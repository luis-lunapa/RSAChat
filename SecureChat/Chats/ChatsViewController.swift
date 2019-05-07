//
//  ChatsViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 5/6/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController, UITextViewDelegate {
    
   // var friendMsg = [Message]()
    var messages = [Message]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var msgTextView: UITextView!
    
  
   
    
    @IBOutlet weak var messageTxtView: UITextView!
   
   
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomNewMessage: NSLayoutConstraint!
    
    
    var friend: Friend!
    
    var messagesTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.messageTxtView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)
        self.messages = [Message.init(plainText: "Hello", sentByMe: true), Message.init(plainText: "Who are you?", sentByMe: false), Message.init(plainText: "My name is Luis", sentByMe: true), Message.init(plainText: "What do you want ?", sentByMe: false) ]
        self.collectionView.delegate    = self
        self.collectionView.dataSource  = self
        
        //self.msgTextView.inputAccessoryView = self.messageComposerView
        
        self.messageTxtView.layer.cornerRadius = 12
        
//        messagesTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {
//            timer in
            self.getMessages()
     //   }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func getMessages() {
        
        let user = AppManager.shared.persistencia.currentUser!
        
        AppManager.shared.networking.getMessages(fromIdUser: self.friend.idUser).done {
            messages in
            
            self.messages = messages
            for m in self.messages {
                m.plainText = NewRSA.decrypt(cipher: m.base64EncryptedString!, private_key: user.privateKey)
            }
            
            self.collectionView.reloadData()

            }.catch {
                error in
                let error = error as NSError
                
                
                self.showAlert(title: "Oops", text: error.userInfo["msg"] as! String)
                
                
                
        }
    }

    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if self.messageTxtView.text == "" {
            return
        }
        
       
        let msg = self.messageTxtView.text!
        
        let cipher = NewRSA.encrypt(msg: msg, public_key: friend.public_key_base64)
        
        if let cipherText = cipher {
            
            AppManager.shared.networking.sendMessage(toIdUSer: self.friend.idUser, msg: cipherText).done {
                ready in
                let msg = Message.init(plainText: self.messageTxtView.text, sentByMe: true)
                self.messageTxtView.text = ""
                self.messageTxtView.resignFirstResponder()
                
                self.messages.append(msg)
                self.collectionView.reloadData()
                
                

                }.catch {
                    error in
                    let error = error as NSError
                    
                    
                    self.showAlert(title: "Oops", text: error.userInfo["msg"] as! String)
                    
                    
                    
            }
        } else {
            self.showAlert(title: "Error :(", text: "Message could not be encrypted")
        }
        
        
        
       // print("Cipher = \(cipher)")
        
//        let user = AppManager.shared.persistencia.currentUser!
//
//
//        print("Public key == \(friend.public_key_base64)")
//        print("Private key == \(user.privateKey!)")
//
//        let clear = NewRSA.decrypt(cipher: "crCqaTuyCs1SasmiL2mlVQhuhZZild5xbikcUzIhazqwH+a8cBr5qGVXTUwdgJkYA8qY+/EwEAdywqAAEsbxi/3c3UNmmBRSsrP7QhQ7ix9ECTPU3zoWcu/UmnL2WQsFjWYiDGF2oD5Pn/+QAWXqmOS7Tu785TlvY7F/VK7zQAONLyUTMcG3/LVXeBEN+t/g/dIPyQ08V8fB0fQXtwmhUcR97yg5Ngvk/MQn8gM50MHkG6pERB42CBqJgVPGn6exDi5MbowgATgIuE4QmDTBNDwVb/vxld5hfEG60TQ39lrfa3TpePt48D1RqzsXr9TxGzud2o3OiFfdHtRRe1aeYw==", private_key: user.privateKey)
//
//        print("Clear TEXT  = \(clear)")
//
////        let texto =  RSA.encriptar(mensaje: msg, e: e, n: n)
////         print("cipher msg == \(texto)")
//
//    //    let des = RSA.desEncriptar(base64Cipher: texto!, d: d, n: n)
//
//        // Msg encriptado = MTg1ODc1MzE4NTg3OTAxODU4Nzg5MTg1ODc5MjE4NTg3MjkxODU4NzI4
//
//
//
//
//
//        print("cipher text == \(cipher)")
        
        
        
    
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleKeyBoard(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyBoardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                //print("TAMANO KEYBOARD ++ \(keyBoardFrame.cgRectValue)")
                let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
                // print("IS KEYBOARD SHOWING == \(isKeyBoardShowing)")
                
                bottomNewMessage?.constant = isKeyBoardShowing ? keyBoardFrame.cgRectValue.height : 0
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {
                    completed in
                    if isKeyBoardShowing {
                        if !self.messages.isEmpty {
                            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                           
                             self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                        }
                        
                    }
                    
                    
                })
                
                
            }
            
            
        }
    }
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }

}

extension ChatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "friendMsg", for: indexPath) as! MessageCollectionViewCell
        
        let msg = self.messages[indexPath.item]
        
        cell.messageTextView.text = msg.plainText
        
        if let messageText = self.messages[indexPath.item].plainText {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !msg.sentByMe {
                cell.messageTextView.frame = CGRect.init(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect.init(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black
            } else {
                
                cell.messageTextView.frame =  CGRect.init(x: view.frame.width - estimatedFrame.width - 32, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
               
                
                cell.textBubbleView.frame = CGRect.init(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
              
                
                cell.textBubbleView.backgroundColor = UIColor.init(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = .white
                cell.profileImageView.isHidden = true
            }
            
            
        }
        
       
       
    
        return cell


        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        
        if let messageText = self.messages[indexPath.item].plainText {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize.init(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize.init(width: view.frame.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    
    
    
    
    
    
    
}
