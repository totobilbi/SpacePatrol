//
//  GameOverScene.swift
//  Space Patrol
//
//  Created by HACKERU on 07/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDetailsScene: SKScene {
    
    var detailsHeight:CGFloat = 0

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)
            
            switch nodeTapped[0].name {
            case "startButton":
                moveToGameScene(self)
            case "exitButton":
                moveToLevelSelectionScene(self)
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
         Mercury, Venus, etc
         */
        addLabel(text: "\(planets[currentEpisode])",
                 fontSize: 90,
                 fontColor: SKColor.white,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.85),
                 zPosition: 2)
        
        /*
         Level number
         */
        addLabel(text: "Level \(currentLevel)",
                 fontSize: 80,
                 fontColor: SKColor.white,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.81),
                 zPosition: 2)

        /*
         Current level storyline
         */
        addLevelDetails(details:Levels.shared.gameLevels[currentEpisode][currentLevel-1]["storyline"] as! String)
        
         /*
          Window background
          */
        
         addImage(name: "window",
                  size: CGSize(width: size.self.width*0.6, height:  self.size.height*0.8),
                  position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.5),
                  zPosition: 1)
        
        
//        addLabel(text: String(Levels.shared.gameLevels[currentEpisode][currentLevel-1]["numberOfEnemies"] as! Int) ,
//                 fontSize: 90,
//                 fontColor: SKColor.white,
//                 position: CGPoint(x: self.size.width*0.345, y: self.size.height*0.58),
//                 zPosition: 2)
//
//        addImage(name: "enemyIcon",
//                 scale: 2.5,
//                 position: CGPoint(x: self.size.width*0.40, y: self.size.height*0.6),
//                 zPosition: 2)
//
//
//        addLabel(text: String(Levels.shared.gameLevels[currentEpisode][currentLevel-1]["livesNumber"] as! Int),
//                 fontSize: 90,
//                 fontColor: SKColor.white,
//                 position: CGPoint(x: self.size.width*0.58, y: self.size.height*0.58),
//                 zPosition: 2)
//
//        addImage(name: "livesIcon",
//                 scale: 2.5,
//                 position: CGPoint(x: self.size.width*0.65, y: self.size.height*0.6),
//                 zPosition: 2)
//
        

        addImage(name: "record",
                 scale: 1.3,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*(detailsHeight-0.05)),
                 zPosition: 2)

        addStars()

    
        addImage(name: "startButton",
                 scale: 0.7,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.23),
                 zPosition: 2)
        
        addImage(name: "exitButton",
                 scale: 0.7,
                 position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.17),
                 zPosition: 2)
        


    }
    
    
    
    
    /*
     Add stars to the scene accoridng to player highscore on the level
     */
    func addStars() {
        let defaults = UserDefaults()
        let highScore = defaults.integer(forKey: "e\(currentEpisode)l\(currentLevel-1)")

        var firstStar:SKSpriteNode, secondStar:SKSpriteNode, thirdStar:SKSpriteNode
            
        switch highScore {
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
                firstStar = makeStar(type: "blueStar")
                secondStar = makeStar(type: "blueStar")
                thirdStar = makeStar(type: "blueStar")
            break
        }
        
        firstStar.position = CGPoint(x: self.size.width*0.35, y: self.size.height*(detailsHeight-0.20))
        secondStar.position = CGPoint(x: self.size.width*0.50, y: self.size.height*(detailsHeight-0.15))
        thirdStar.position = CGPoint(x: self.size.width*0.65, y: self.size.height*(detailsHeight-0.20))
        
        self.addChild(firstStar)
        self.addChild(secondStar)
        self.addChild(thirdStar)
    }
    
    
    /*
     Make a star image according to type (blue, yellow, grey)
     */
    func makeStar(type:String) -> SKSpriteNode {
        let star = SKSpriteNode(imageNamed: type)
        star.setScale(0.8)
        star.zPosition = 2
        return star
    }
    
    
    
    /*
     Add text labels to the screen using the array of strings
     */
    func addDetailsLabels(strings:[String]) {
        var heightMulti:CGFloat = 0.75
        for str in strings {
            addLabel(text: str,
                     fontSize: 40,
                     fontColor: SKColor.white,
                     position: CGPoint(x: self.size.width*0.5, y: self.size.height*heightMulti),
                     zPosition: 2)
            heightMulti-=0.02
        }
        
        detailsHeight = heightMulti
    }
    
    
    
    /*
     Substring a long string to an array of strings
     Each string is around 30-40 characters
     Send the strings array to addDetailsLabels()
     */
    func addLevelDetails(details:String) {
        var startIndex = 0
        var endIndex = 30
        var strings:[String] = []
        while endIndex < details.count {
            while details[endIndex] != " " {
                endIndex+=1
            }
            strings.append(details.substring(with: startIndex..<endIndex))
            endIndex+=1
            startIndex = endIndex
            
            if endIndex + 30 > details.count {
                strings.append(details.substring(with: startIndex..<details.count))
            }
            
            endIndex+=30
        }
        
        addDetailsLabels(strings: strings)
    }
    
    

    
}
