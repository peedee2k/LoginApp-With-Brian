//
//  ChatLogController.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 2/9/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var user: MyUser? {
        didSet {
            
            navigationItem.title = user?.Name
            observeMessages()
        }
    }
    var messageArray = [Messages]()
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toID = user?.id else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid).child(toID)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
     
            let messageRef = Database.database().reference().child("messages").child(messageID)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
                guard let myDict = snapshot.value as? [String: AnyObject] else { return }
                
                let message = Messages(myMessageDict: myDict)
                
                self.messageArray.append(message)
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                   let indexPath = IndexPath(item: self.messageArray.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    
                    })
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
   lazy var inputTextField: UITextField = {
        let inputText = UITextField()
        
        
        inputText.placeholder = "Enter message..."
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.delegate = self
        return inputText
    }()
    
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.keyboardDismissMode = .interactive
        
 //       setupInputComponent()
//        setUpKeyboardObserver()
        
    }
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageIconTapped)))
        containerView.addSubview(uploadImageView)
        // Setup Constrain for uploadImageView
        
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Setup TextField
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        // Setup SepretorLine
        
        let sepretorLine = UIView()
        sepretorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        sepretorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sepretorLine)
        
        sepretorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        sepretorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        sepretorLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        sepretorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true

        
        return containerView
    }()
    
    @objc private func imageIconTapped() {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedProfileImage: UIImage?
        if let editdImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedProfileImage = editdImage
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedProfileImage = pickedImage
        }
        if let selectedImage = selectedProfileImage {
            uploadToFirebaseStorageUsingImage(image: selectedImage)
            
        }
        dismiss(animated: true, completion: nil)
    }
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageID = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageID)
        let uploadData = UIImageJPEGRepresentation(image, 0.2)
        ref.putData(uploadData!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            } else {
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageURL(imageURL: imageURL, image: image)
                }
                
            }
        }
    }
    
  
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Tapped")
        dismiss(animated: true, completion: nil)
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
                    }
                }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setUpKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messageArray.count > 0 {
            let indexPath = IndexPath(item: messageArray.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        containerViewBottomAnchor?.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
      
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        let message = messageArray[indexPath.row]
        cell.textView.text = message.text
        
        setUpCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.bubbleWithAnchor?.constant = estimeteFrameForText(text: text).width + 32
        } else if message.imageURL != nil {
            cell.bubbleWithAnchor?.constant = 200
        }
       
    
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Messages) {
       
        if let imageForText = self.user?.ProfileImage {
             cell.profileImageForChatController.loadImageUseingCacheWithUrlString(urlString: imageForText)
                }
        
        if let messageImageURL = message.imageURL {
            cell.messageImageView.loadImageUseingCacheWithUrlString(urlString: messageImageURL)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
            
        }
   
        if message.fromID == Auth.auth().currentUser?.uid {
            // Outgoing Message from User
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false

            cell.profileImageForChatController.isHidden = true
        } else {
            // Incoming Message
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageForChatController.isHidden = false
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var height: CGFloat = 80
        let message = messageArray[indexPath.item]
        if let text = message.text {
            height = estimeteFrameForText(text: text).height + 20
        } else if let imageheight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue {
            height = CGFloat(imageheight / imageWidth * 200)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimeteFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return  NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    @objc func handleSend() {
        if inputTextField.text != "" {
            let properties: [String : Any] = ["text": inputTextField.text!]
            sendMessageWithProperties(properties: properties)
            }
                inputTextField.text = ""
        }
    
    
    
    private func sendMessageWithImageURL(imageURL: String, image: UIImage) {
        let properties : [String: Any] = ["imageURL": imageURL, "imageHeight": image.size.height  , "imagewidth": image.size.width]
        
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: Any]) {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let date = Date()
        let timestamp = Int(date.timeIntervalSince1970)
        var value: [String: Any] = ["toID": toID, "fromID": fromID, "timestamp": timestamp]
        
        // append properties
        // key = $0 and value = $1
        properties.forEach { value[$0] = $1 }
        
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
                
                let messageID = childRef.key
                userMessagesRef.updateChildValues([messageID: 1])
                
                let recepiantUserMessasgesRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
                recepiantUserMessasgesRef.updateChildValues([messageID: 1])
            }
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
