//
//  ShowHUD+extensions.swift
//  FireChat
//
//  Created by HACKERU on 06/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import PKHUD

protocol ShowHUD {
    //abstract methods
}

extension ShowHUD {
    //concrete methods: (methods with body {code}
    func showProgress(title: String? = nil, subtitle: String? = nil) {
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title: String? = nil, subtitle:String? = nil) {
        HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 2)
    }
    
    func showSuccess(title: String? = nil, subtitle:String? = nil) {
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle), delay: 2)
    }
    
    func showLabel(title: String) {
        HUD.flash(.label(title), delay: 1)
    }
    
    func dismissProgress() {
        
    }
}

extension UIViewController: ShowHUD {}

