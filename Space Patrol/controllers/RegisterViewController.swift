//
//  RegisterViewController.swift
//  FireChat
//
//  Created by HACKERU on 06/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var windowImage: UIImageView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    
    @IBOutlet weak var registerImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var registerTapped = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignBackground(imageName: "firstBackground")
        nameTextField.becomeFirstResponder()
        
        
        
           
               //load window image
               windowImage.image = UIImage(named: "window")
               _ = UIImage(named: "window")


               //load back image from asset
               backImage.image = UIImage(named: "backButton")

               //tap gesture for back image
               var tap = UITapGestureRecognizer(target: self, action: #selector(popBack))
               backImage.addGestureRecognizer(tap)
               backImage.isUserInteractionEnabled = true


               //load accept image from asset
               registerImage.image = UIImage(named: "acceptButton")
        

               //tap gesture for image
               tap = UITapGestureRecognizer(target: self, action: #selector(register))
               registerImage.addGestureRecognizer(tap)
               registerImage.isUserInteractionEnabled = true
    }
    
    
    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func register() {
        guard isEmailValid && isPasswordValid,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        
        //if the nickname is empty (split the email)
        var nickName = nameTextField.text!
        nickName = !nickName.isEmpty ? nickName : String(email.split(separator: "@")[0])
        
        showProgress(title: "Please wait...")
        
        registerTapped = true
        
        //firebase auth:
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] (result, error) in
            
            //error:
            guard let result = result else {
                let errorMessage = error?.localizedDescription ?? "Unkown error"
                print(errorMessage)
                self?.showError(title: "Register Failed", subtitle: errorMessage)
                self?.registerTapped = false
                return
            }
            
            //success we have user
            let user = result.user
            
            //update nickname:
            let profileChangeRequest = user.createProfileChangeRequest()
            profileChangeRequest.displayName = nickName
            
            //apply the nickname (profile change request)
            profileChangeRequest.commitChanges { (error) in
                if let error = error {
                    let errorMessage = error.localizedDescription
                    self?.showError(title: "Couldn't update nickname", subtitle: errorMessage)
                } else {
                    self?.showSuccess()
                    Router.shared.chooseMainViewController()
                }
            }
            
        }
    }

}




