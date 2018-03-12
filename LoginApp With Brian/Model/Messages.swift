//
//  Messages.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 2/16/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

class Messages: NSObject {
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    var imageURL: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?

    init(myMessageDict: [String: Any]) {
        let fromID = myMessageDict["fromID"] as? String
        let text = myMessageDict["text"] as? String
        let timeStamp = myMessageDict["timeStamp"] as? NSNumber
        let toID = myMessageDict["toID"] as? String
        let imageURL = myMessageDict["imageURL"] as? String
        let imageHeight = myMessageDict["imageHeight"] as? NSNumber
        let imageWidth = myMessageDict["imageHeight"] as? NSNumber
        self.fromID = fromID
        self.text = text
        self.timestamp = timeStamp 
        self.toID = toID
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        
        
    }
    
    func chatPartnerID() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
//      if fromID == Auth.auth().currentUser?.uid {
//              return toID!
//        } else {
//
//            return fromID!
//        }
    }

}
