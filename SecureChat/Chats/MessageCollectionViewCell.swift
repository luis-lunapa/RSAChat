//
//  MessageCollectionViewCell.swift
//  SecureChat
//
//  Created by Luis Luna on 5/6/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var textBubbleView: UIView!
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.textBubbleView.layer.cornerRadius = 15
        self.textBubbleView.layer.masksToBounds = true
        
        self.addSubview(profileImageView)
        self.addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        self.addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        self.profileImageView.image = UIImage(named: "profilePic")
        self.profileImageView.circleImage()
        
        
    }
    
}
