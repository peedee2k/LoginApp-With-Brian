//
//  NewMessageController.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/21/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellID = "cellID"
    var user = [MyUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonHandle))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        fatchUsers()
    }
    
    func fatchUsers() {
        Database.database().reference().child("User").observe(.childAdded, with: { (snapshot) in
           
            if let myDict = snapshot.value as? [String: AnyObject] {
    
                    let users = MyUser(dict: myDict)
                    users.id = snapshot.key
                    users.ProfileImage = myDict["ProfileImageURL"] as? String
                    self.user.append(users)
                
                    DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            
            }
        }, withCancel: nil)
    }
    
    @objc func cancelButtonHandle() {
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let myuser = user[indexPath.row]
        cell.textLabel?.text = myuser.Name
        cell.detailTextLabel?.text = myuser.Email
        
      
        if let imageURL = myuser.ProfileImage {
            
            cell.profileImageViewCell.loadImageUseingCacheWithUrlString(urlString: imageURL)
            }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    var messageController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
           let users = self.user[indexPath.row]
            self.messageController?.showChatController(myUser: users)
        }
    }
}


