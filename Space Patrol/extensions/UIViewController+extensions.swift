//
//  UIViewController+extensions.swift
//  Space Patrol
//
//  Created by HACKERU on 19/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit

extension UIViewController {
    func assignBackground(imageName:String){
            let background = UIImage(named: imageName)
            var imageView : UIImageView!
        
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
    }

}


extension UIView {
    func assignBackground(imageName:String){
            let background = UIImage(named: imageName)
            var imageView : UIImageView!
        
            imageView = UIImageView(frame: self.bounds)
            imageView.contentMode =  .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = self.center
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
    }

}

    
