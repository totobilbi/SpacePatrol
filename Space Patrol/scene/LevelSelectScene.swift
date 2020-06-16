//
//  LevelSelectScene.swift
//  Space Patrol
//
//  Created by HACKERU on 22/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit


var levelsRecord:[Int] = []
var currentLevel:Int = 0

class LevelSelectScene: SKScene {

   
    var levelsPosition:[CGPoint] = []

    
    override func didMove(to view: SKView) {
        adjustLevelsPosition()
        getCurrentLevelRecord()
        adjustScene()
        adjustLevels()
    }
    
    
    
    func adjustScene() {
        addBackground(imageNamed: "firstBackground",
                           position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                           size: self.size,
                           zPosition: 0)

             addLabel(name: "title",
                      text: planets[currentEpisode],
                       fontSize: 120,
                       fontColor: SKColor.white,
                       position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.90),
                       zPosition: 1)
             
             
             addImage(name: "window",
                      size: CGSize(width: size.self.width*0.6, height:  self.size.height*0.7),
                      position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                      zPosition: 1)
             
             
             addLabel(name: "subtitle",
                      text: "select level",
                       fontSize: 100,
                       fontColor: SKColor.white,
                       position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.78),
                       zPosition: 2)
        
            addImage(name: "exitButton",
                     scale: 1,
                     position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.22),
                     zPosition: 2)
    }
    
    
    
    func adjustLevels() {
        for i in 0..<9 {
            if i == 0 {
                addImage(imageName: "level1",
                         name: "1",
                         size: CGSize(width: 250, height: 250),
                         position: levelsPosition[i],
                         zPosition: 2)
            } else {
                if levelsRecord[i-1] >= 1 {
                    addImage(imageName: "level\(i+1)",
                             name: "\(i+1)",
                             size: CGSize(width: 250, height: 250),
                             position: levelsPosition[i],
                             zPosition: 2)
                } else {
                    addImage(imageName: "levelLocked",
                             name: "locked",
                             size: CGSize(width: 250, height: 250),
                             position: levelsPosition[i],
                             zPosition: 2)
                }
            }
        }
    }
    
    
    
    func getCurrentLevelRecord() {
        for i in 0..<9 {
            //e0l0 - episode 0 level 0
            //e0l1 - episode 0 level 1
            let levelScore = UserDefaults().integer(forKey: "e\(currentEpisode)l\(i)")
            levelsRecord.append(levelScore)
        }
    }
    
    
    func adjustLevelsPosition() {
        levelsPosition =
            [
                CGPoint(x: self.size.width*0.3, y: self.size.height*0.65),
                CGPoint(x: self.size.width*0.5, y: self.size.height*0.65),
                CGPoint(x: self.size.width*0.7, y: self.size.height*0.65),
                CGPoint(x: self.size.width*0.3, y: self.size.height*0.50),
                CGPoint(x: self.size.width*0.5, y: self.size.height*0.50),
                CGPoint(x: self.size.width*0.7, y: self.size.height*0.50),
                CGPoint(x: self.size.width*0.3, y: self.size.height*0.35),
                CGPoint(x: self.size.width*0.5, y: self.size.height*0.35),
                CGPoint(x: self.size.width*0.7, y: self.size.height*0.35),
            ]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)
            
            var clickedLevel = nodeTapped[0].name ?? "none"
            
            if clickedLevel == "exitButton" {
                moveToEpisodeSelectScene(self)
            } else {
                let decimalRange = clickedLevel.rangeOfCharacter(from: .decimalDigits)
            
                if decimalRange != nil {
                    currentLevel = Int(String(clickedLevel.last!)) ?? 0
                    Levels.shared.currentLevel = Levels.shared.gameLevels[currentEpisode][currentLevel-1]
                    moveToLevelDetailsScene(self)
                }

                
            }
        }
    }
    
    

    
    
}
