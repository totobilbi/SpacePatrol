//
//  Router.swift
//  Space Patrol
//
//  Created by HACKERU on 19/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import FirebaseAuth

//determine root view controller for the app (login or chat)
//if the user is already logged in -> Chat
// if no user -> Login

class Router {
    
    //the apps main window
    weak var window: UIWindow?
    
    //is the user logged in or not:
    var isLoggedIn:Bool {
        return Auth.auth().currentUser != nil
    }
    
    //singleton
    private init() {}
    static let shared = Router()
    
    
    
    func chooseMainViewController() {
        //make suere that we are on the ui thread
        guard Thread.current.isMainThread else {
            //call this method again on the ui thread:
            DispatchQueue.main.async { [weak self] in
                self?.chooseMainViewController()
            }
            return
        }
        
        //UI Thread:
        let fileName = isLoggedIn ? "Main" : "Login"
        let sb = UIStoryboard(name: fileName, bundle: .main)
        
        window?.rootViewController = sb.instantiateInitialViewController()
    }
    
}
