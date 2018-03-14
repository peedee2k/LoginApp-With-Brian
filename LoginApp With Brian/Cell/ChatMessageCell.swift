//
//  ChatMessageCell.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 3/3/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    
    
    
    var textView: UITextView = {
       var tv = UITextView()
        tv.text = "Sample Text"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.cornerRadius = 16
        bubble.layer.masksToBounds = true
        bubble.backgroundColor = blueColor
        return bubble
        
    }()
    
    let profileImageForChatController: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "moon")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.backgroundColor = UIColor.white
        return image
    }()
    
    lazy var messageImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "moon")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomInImageview)))
        
        
        return image
    }()
    
    @objc func handleZoomInImageview(gestureRecognizer: UITapGestureRecognizer) {
    
        if let imageView = gestureRecognizer.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
        
        
        
        
    }
    
    var bubbleWithAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageForChatController)
        bubbleView.addSubview(messageImageView)
        
        // iOS 9 Constrains for textView
        // x, y, width and height
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //iOS Constrains for bubbleView
        // x, y, Width and Height 
        
        bubbleViewRightAnchor =  bubbleView.rightAnchor.constraint(equalTo:self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageForChatController.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWithAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWithAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //iOS Constrains for imageView
        // x, y, Width and Height
        
        profileImageForChatController.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageForChatController.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageForChatController.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageForChatController.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        // iOS Constrain for messageImage in BubbleView
        // x, y, Width and Height
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
