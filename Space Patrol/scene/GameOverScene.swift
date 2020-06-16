//
//  GameOverScene.swift
//  Space Patrol
//
//  Created by HACKERU on 07/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)
            
            switch nodeTapped[0].name {
            case "playButton":
                moveToNextLevel()
            case "closeButton":
                moveToLevelSelectionScene(self)
            case "replayButton":
                moveToGameScene(self)
            default:
                break
            }
            
        }
    }

    override func didMove(to view: SKView) {
        addBackground(imageNamed: "background",
                      position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                      size: self.size,
                      zPosition: 0)
        adjustScene()
    }
    
    
    func adjustScene() {
           /*
          Window background
          */
        
         addImage(name: "window",
                  size: CGSize(width: size.self.width*0.6, height:  self.size.height*0.6),
                  position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.5),
                  zPosition: 1)

        
        addImage(name: isGameWon ? "win" : "lose",
                 scale: 1.2,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.75),
                 zPosition: 2)
        
        
        addImage(name: "score",
                 scale: 1.2,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.6),
                 zPosition: 2)
        
        addStars()
        
        addBottomButtons()
    }
    
    
    
    
    func addStars() {
        let defaults = UserDefaults()
        let highScore = defaults.integer(forKey: "e\(currentEpisode)l\(currentLevel-1)")

        if livesNumber > highScore {
            defaults.set(livesNumber, forKey: "e\(currentEpisode)l\(currentLevel-1)")
        }
        
        var firstStar:SKSpriteNode, secondStar:SKSpriteNode, thirdStar:SKSpriteNode
            
        switch livesNumber {
            case 1:
                firstStar = makeStar(type: "yellowStar")
                secondStar = makeStar(type: "greyStar")
                thirdStar = makeStar(type: "greyStar")
            break
            
            case 2:
                firstStar = makeStar(type: "yellowStar")
                secondStar = makeStar(type: "yellowStar")
                thirdStar = makeStar(type: "greyStar")
            break
                
            case 3:
                firstStar = makeStar(type: "yellowStar")
                secondStar = makeStar(type: "yellowStar")
                thirdStar = makeStar(type: "yellowStar")
            break
            
            default:
                firstStar = makeStar(type: "greyStar")
                secondStar = makeStar(type: "greyStar")
                thirdStar = makeStar(type: "greyStar")
            break
        }
        
        firstStar.position = CGPoint(x: self.size.width*0.35, y: self.size.height*0.45)
        secondStar.position = CGPoint(x: self.size.width*0.50, y: self.size.height*0.50)
        thirdStar.position = CGPoint(x: self.size.width*0.65, y: self.size.height*0.45)
        
        self.addChild(firstStar)
        self.addChild(secondStar)
        self.addChild(thirdStar)
    }
    
    
    func makeStar(type:String) -> SKSpriteNode {
        let star = SKSpriteNode(imageNamed: type)
        star.setScale(0.8)
        star.zPosition = 2
        return star
    }
    
    
    func moveToNextLevel() {
        if currentLevel == 9 {
            currentEpisode += 1
            currentLevel = 1
        } else {
            currentLevel += 1
        }
        moveToLevelDetailsScene(self)
    }

    
    
    func addBottomButtons() {
        if isGameWon {
            addImage(name: "closeButton",
                     scale: 0.8,
                     position: CGPoint(x: self.size.width*0.29, y: self.size.height*0.26),
                     zPosition: 2)
            
            addImage(name: "replayButton",
                     scale: 0.8,
                     position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.26),
                     zPosition: 2)
            
            addImage(name: "playButton",
                     scale: 0.8,
                     position: CGPoint(x: self.size.width*0.71, y: self.size.height*0.26),
                     zPosition: 2)
        } else {
            addImage(name: "closeButton",
                     scale: 0.8,
                     position: CGPoint(x: self.size.width*0.29, y: self.size.height*0.26),
                     zPosition: 2)
            
            addImage(name: "replayButton",
                     scale: 0.8,
                     position: CGPoint(x: self.size.width*0.71, y: self.size.height*0.26),
                     zPosition: 2)
        }

    }
}
