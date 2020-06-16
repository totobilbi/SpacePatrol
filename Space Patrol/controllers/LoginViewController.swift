//
//  LoginViewController.swift
//  Space Patrol
//
//  Created by HACKERU on 06/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {


    
    @IBOutlet weak var loginImage: UIImageView!
    
    @IBOutlet weak var windowImage: UIImageView!
    
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginTapped = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assign background
        self.assignBackground(imageName: "firstBackground")
        emailTextField.becomeFirstResponder()
        
//        let window = makeCenterdImage(imageName: "window", frame: CGRect(x: 0, y: 0, width: view.bounds.width*0.9, height: view.bounds.height*0.4))
//
//        view.addSubview(window!)
        
        

        
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
        loginImage.image = UIImage(named: "acceptButton")
 

        //tap gesture for image
        tap = UITapGestureRecognizer(target: self, action: #selector(login))
        loginImage.addGestureRecognizer(tap)
        loginImage.isUserInteractionEnabled = true
        
    }
    

    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func login() {
        if !loginTapped {
            guard isEmailValid && isPasswordValid,
                let email = emailTextField.text,
                let password = passwordTextField.text
                else {return}
            

            showProgress(title: "Please wait...")
            
            loginTapped = true
            
            //firebase auth:
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] (result, error) in
                
                //error:
                guard let _ = result else {
                    let errorMessage = error?.localizedDescription ?? "Unkown error"
                    self?.showError(title: "Login Failed", subtitle: errorMessage)
                    self?.loginTapped = false
                    return
                }
                
                self?.showSuccess()
                Router.shared.chooseMainViewController()
            }
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

