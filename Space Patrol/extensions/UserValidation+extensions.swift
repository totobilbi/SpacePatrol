//
//  UserValidation+extensions.swift
//  FireChat
//
//  Created by HACKERU on 06/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit

protocol UserValidation: ShowHUD {
    var emailTextField:UITextField!{get}
    var passwordTextField:UITextField!{get}
}

extension UserValidation {
    var isEmailValid:Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            showLabel(title: "Email must not be empty")
            return false
        }
        return true
    }
    
    var isPasswordValid:Bool {
        guard let password = emailTextField.text, !password.isEmpty else {
            showLabel(title: "Password must not be empty")
            return false
        }
        return true
    }
}

extension LoginViewController: UserValidation{}
extension RegisterViewController: UserValidation{}
