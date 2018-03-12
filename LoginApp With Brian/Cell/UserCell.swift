//
//  UserCell.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 2/21/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import  Firebase

class UserCell: UITableViewCell {
    
    var message: Messages? {
        didSet {
            
            setUpNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timeStempsDate = Date(timeIntervalSince1970: seconds)
                let dateFormetter = DateFormatter()
                dateFormetter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormetter.string(from: timeStempsDate)
            }
            
            
            
        }
    }
    
    private func setUpNameAndProfileImage() {
       
    
        
        if let id = message?.chatPartnerID() {
            let ref = Database.database().reference().child("User").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? [String: Any]
                self.textLabel?.text = dict!["Name"] as? String
                if let profileImageURL = dict!["ProfileImageURL"] as? String {
                    self.profileImageViewCell.loadImageUseingCacheWithUrlString(urlString: profileImageURL)
                    }
                }, withCancel: nil)
            
        }
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageViewCell: UIImageView = {
        let imageCell = UIImageView()
        imageCell.layer.cornerRadius = 25
        imageCell.layer.masksToBounds = true
        imageCell.contentMode = .scaleToFill
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        return imageCell
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier!)
        
        addSubview(profileImageViewCell)
        addSubview(timeLabel)
        
        // Setup Constrains X, Y, Height and width
        profileImageViewCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageViewCell.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageViewCell.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageViewCell.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Setup Constrains X, Y, Height and width for timeLabel
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
       timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
