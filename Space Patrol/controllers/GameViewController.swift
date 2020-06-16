//
//  GameViewController.swift
//  Space Patrol
//
//  Created by HACKERU on 05/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       
    
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let view = self.view as! SKView
        if view.scene == nil {
            // Load the SKScene from 'GameScene.sks'
             let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
