//
//  MainMenuScene.swift
//  Space Patrol
//
//  Created by HACKERU on 21/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        addBackground(imageNamed: "firstBackground",
                      position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                      size: self.size,
                      zPosition: 0)
        adjustScene()
    }
    
    
    func adjustScene() {
        addImage(name: "infoButton",
                 scale: 0.5,
                 position: CGPoint(x: self.size.width*0.23, y: self.size.height*0.96),
                 zPosition: 1)
        
        addImage(name: "settingsButton",
                 scale: 0.5,
                 position: CGPoint(x: self.size.width*0.77, y: self.size.height*0.96),
                 zPosition: 1)
        
        addLabel(text: "roeico7 Studio",
                 fontSize: 30,
                 fontColor: SKColor.white,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.68),
                 zPosition: 1)
        
        addLabel(text: "Space",
                 fontSize: 200,
                 fontColor: SKColor.white,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.6),
                 zPosition: 1)
        
        addLabel(text: "Patrol",
                 fontSize: 200,
                 fontColor: SKColor.white,
                 position: CGPoint(x: self.size.width*0.51, y: self.size.height*0.525),
                 zPosition: 1)
        
        addImage(name: "startButton",
                 scale: 1,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.35),
                 zPosition: 1)
        
        addImage(name: "exitButton",
                 scale: 1,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.25),
                 zPosition: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)
            
            switch nodeTapped[0].name {
            case "startButton":
                moveToEpisodeSelectScene(self)
            default:
            break
            }
        }
    }
    
}
