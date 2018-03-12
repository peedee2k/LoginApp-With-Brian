//
//  LogInController.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/18/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    
    var messagesController: MessagesController?
    // View with Name, Email and password
    
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // Register Button
    let logInRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 175)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    // Register and login Button
    
    @objc func handleLoginRegister() {
        if segmentedController.selectedSegmentIndex == 0 {
            handleLogIn()
        } else {
            handleRegisterBtn()
        }
    }
    
    func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    

    // Profile Image
    lazy var profileImageView: UIImageView = {
        let proImage = UIImageView()
        proImage.image = UIImage(named: "gameofthrones_splash")
        proImage.translatesAutoresizingMaskIntoConstraints = false
        proImage.contentMode = .scaleAspectFill
        
        proImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectedProfileImage)))
        proImage.isUserInteractionEnabled = true
        return proImage
        }()
    
   
    
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSepretor: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        lineView.translatesAutoresizingMaskIntoConstraints = false
       return lineView
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailSepretor: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let segmentedController: UISegmentedControl = {
        var sc = UISegmentedControl()
       sc = UISegmentedControl(items: ["LogIn", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return sc
    }()
    @objc func handleLoginRegisterChanged() {
        let title = segmentedController.titleForSegment(at: segmentedController.selectedSegmentIndex)
        logInRegisterButton.setTitle(title, for: .normal)
        inputViewHeightAnchor?.constant = segmentedController.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextfieldHeightAnchor?.isActive = false
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextfieldHeightAnchor?.isActive = true
       
        emailTextfieldHeightAnchor?.isActive = false
        emailTextfieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextfieldHeightAnchor?.isActive = true
        
        passwordTextfieldHeightAnchor?.isActive = false
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextfieldHeightAnchor?.isActive = true
        
        
        
        
        // Set up height for inputview
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputContainerView)
        view.addSubview(logInRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(segmentedController)
        setUpConstrinForLogInView()
        setUpRegisterButton()
        setupProfileImage()
        setUpSegmentedcomntroller()
    
       
    }
    var inputViewHeightAnchor: NSLayoutConstraint?
    var nameTextfieldHeightAnchor: NSLayoutConstraint?
    var emailTextfieldHeightAnchor: NSLayoutConstraint?
    var passwordTextfieldHeightAnchor: NSLayoutConstraint?
    // LogIn View Set up
    func setUpConstrinForLogInView() {
        // Need x, y, width and height constrain
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputViewHeightAnchor?.isActive = true
        
        // Need x, y, width and height constrain
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSepretor)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSepretor)
        inputContainerView.addSubview(passwordTextField)
        
        // Need x, y, width and height constrain
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextfieldHeightAnchor?.isActive = true

        // Need x, y, width and height constrain
        nameSepretor.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSepretor.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSepretor.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSepretor.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constrain
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSepretor.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextfieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextfieldHeightAnchor?.isActive = true
        
        
        
        // Need x, y, width and height constrain
        emailSepretor.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSepretor.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSepretor.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSepretor.heightAnchor.constraint(equalToConstant: 1).isActive = true
       
        // Need x, y, width and height constrain
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSepretor.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextfieldHeightAnchor?.isActive = true
        
    }
    
    func setUpSegmentedcomntroller() {
        
        // Need x.y. width and height constrain
        segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedController.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        segmentedController.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
        
        
    }
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: segmentedController.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    
    // Button Setup
    func setUpRegisterButton() {
        // Need x, y, width and height constrains
        logInRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        logInRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        logInRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

