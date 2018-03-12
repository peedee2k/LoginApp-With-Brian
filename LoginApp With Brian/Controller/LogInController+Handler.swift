//
//  LogInController+Handler.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/22/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

extension LogInController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func handleRegisterBtn() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
       
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print(error!)
            }
            guard let uid = user?.uid else { return }
            let imageID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Profile_Images").child("\(imageID).jpeg")
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
               {
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error!)
                        print("Here is my Error")
                        return
                    }
            if let profileImageURL = metaData?.downloadURL()?.absoluteString {
                
                    let value = ["Name": name, "Email": email, "ProfileImageURL": profileImageURL]
                        
                    self.registerUserDataWithuid(uid: uid, value: value)
                        
                        }
                    })
                }
            }
    }
    func registerUserDataWithuid(uid: String, value: [String: Any]) {
        let ref = Database.database().reference()
        
        let userRef = ref.child("User").child(uid)
        userRef.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil { print(err!) }
            print("We have created a new user")
            
            let user = MyUser(dict: value)
            self.messagesController?.setUpNavBarWithUser(user: user)
       // self.messagesController?.navigationItem.title = value["Name"] as? String
           
            
            self.dismiss(animated: true, completion: nil)
        })
    }
 
 @objc func handleSelectedProfileImage() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
      present(picker, animated: true, completion: nil)
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedProfileImage: UIImage?
        if let editdImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedProfileImage = editdImage
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedProfileImage = pickedImage
            }
        if let selectedImage = selectedProfileImage {
            profileImageView.image = selectedImage
            }
         dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        dismiss(animated: true, completion: nil)
    }
}
