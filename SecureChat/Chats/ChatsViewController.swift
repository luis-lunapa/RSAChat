//
//  ChatsViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 5/6/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
   // var friendMsg = [Message]()
    var messages = [Message]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var msgTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var messageComposerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messages = [Message.init(plainText: "Hello", sentByMe: true), Message.init(plainText: "Who are you?", sentByMe: false), Message.init(plainText: "My name is Luis", sentByMe: true), Message.init(plainText: "What do you want ?", sentByMe: false) ]
        self.collectionView.delegate    = self
        self.collectionView.dataSource  = self
        
        self.msgTextView.inputAccessoryView = self.messageComposerView

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
