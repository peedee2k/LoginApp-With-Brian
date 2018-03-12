//
//  MyUser.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/21/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class MyUser: NSObject {
    var id: String?
    var Name: String?
    var Email: String?
    var ProfileImage: String?
    
    init(dict: [String: Any]) {
        //let id = dict["id"] as! String
        let Name = dict["Name"] as! String
        let Email = dict["Email"] as! String
        let ProfileImage = dict["ProfileImageURL"] as! String
      //  self.id = id
        self.Name = Name
        self.Email = Email
        self.ProfileImage = ProfileImage
    }
}
