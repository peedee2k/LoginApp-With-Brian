//
//  ViewController.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/18/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(handleLogOut))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(newMessageControllerHandle))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)

      
        
    }
    var messages = [Messages]()
    var messageDict = [String: Messages]()
    
    func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: { (snapshot1) in
                let messageID = snapshot1.key
                self.fatchMessageID(messageID: messageID)
                
            }, withCancel: nil)
      }, withCancel: nil)
    }
    
    private func fatchMessageID(messageID: String) {
        let messageReferance = Database.database().reference().child("messages").child(messageID)
        
        messageReferance.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Messages(myMessageDict: dictionary)
                message.text = dictionary["text"] as? String
                message.fromID = dictionary["fromID"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                message.toID = dictionary["toID"] as? String
                //                    //self.messages.append(message)
                
                if let id = message.chatPartnerID() {
                    self.messageDict[id] = message
                }
                self.attempToReloadTable()
            }
        }, withCancel: nil)
        
    }
    
    private func attempToReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
            }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messageDict.values)
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timestamp!.int32Value > m2.timestamp!.int32Value
        })
                DispatchQueue.main.async {
                    print("Reload table")
                    self.tableView.reloadData()
                }
            }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
       
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartner = message.chatPartnerID() else { return }
        
        let ref = Database.database().reference().child("User").child(chatPartner)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else { return }
           
            let user = MyUser(dict: userDict)
            user.id = chatPartner
            
            self.showChatController(myUser: user)
            
        }, withCancel: nil)
     
    }
    
    
    
    @objc func newMessageControllerHandle() {
        let newMessageController = NewMessageController()
        
        //Check bellow line of code
        
        newMessageController.messageController = self
        
        ///////////////////////////////////////////////////
        let naviController = UINavigationController(rootViewController: newMessageController)
        present(naviController, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        
        } else {
            fatchUserAndSetupNewNavBarTitle()
        }
        
        
    }
    func fatchUserAndSetupNewNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("User").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userDict = snapshot.value as? [String: Any] {
               let user = MyUser(dict: userDict)
                
                self.setUpNavBarWithUser(user:user)
            }
        }, withCancel: nil)
        
    }
    func setUpNavBarWithUser(user: MyUser) {
        messages.removeAll()
        messageDict.removeAll()
        tableView.reloadData()
          observeUserMessage()
        
        
        
      let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        //titleView.backgroundColor = .red
        
//        let containerView = UIView()
//        titleView.addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false

         let titleprofileImage = UIImageView()
        

        titleprofileImage.translatesAutoresizingMaskIntoConstraints = false
        titleprofileImage.contentMode = .scaleAspectFit
        titleprofileImage.layer.cornerRadius = 20
        titleprofileImage.clipsToBounds = true
        if let profileImageURL = user.ProfileImage {
            titleprofileImage.loadImageUseingCacheWithUrlString(urlString: profileImageURL)
        }
        titleView.addSubview(titleprofileImage)
        // Use Ios9 Constrains
        // set X, Y, Width and Height
        titleprofileImage.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titleprofileImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleprofileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleprofileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true


        let titleLable = UILabel()
        titleView.addSubview(titleLable)
        titleLable.text = user.Name
        titleLable.translatesAutoresizingMaskIntoConstraints = false


        titleLable.leftAnchor.constraint(equalTo: titleprofileImage.rightAnchor, constant: 8).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: titleprofileImage.centerYAnchor).isActive = true
        titleLable.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        titleLable.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
       
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        

    }
       @objc func showChatController(myUser: MyUser) {
       let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = myUser
        navigationController?.pushViewController(chatLogController, animated: true)
       
    }
    
       @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
         let logInVC = LogInController()
        logInVC.messagesController = self
        present(logInVC, animated: true, completion: nil)
        }
   
    

    

}

