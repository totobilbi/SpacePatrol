//
//  EpisodeSelectScene.swift
//  Space Patrol
//
//  Created by HACKERU on 22/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

var currentEpisode = 0
var planets:[String] = ["mercury", "venus", "mars", "earth"]

class EpisodeSelectScene: SKScene {

    
    var currentPlanet = 0
    var record = 0
    
    override func didMove(to view: SKView) {
        adjustScene()
    }
    
    
    
    func adjustScene() {
        addBackground(imageNamed: "firstBackground",
                      position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                      size: self.size,
                      zPosition: 0)

        addLabel(name: "title",
                 text: "Select Planet",
                  fontSize: 120,
                  fontColor: SKColor.white,
                  position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.85),
                  zPosition: 1)
        
        
        addImage(name: "window",
                 scale: 1,
                 position: CGPoint(x: self.size.width/2, y: self.size.height/2),
                 zPosition: 1)
        
        
        addLabel(name: "planet",
                 text: "mercury",
                  fontSize: 100,
                  fontColor: SKColor.white,
                  position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.7),
                  zPosition: 2)
        
        addImage(name: "mercury",
                 size: CGSize(width: 550, height: 350),
                 position: CGPoint(x: self.size.width/2, y: self.size.height*0.5),
                 zPosition: 2)
        
        addImage(name: "forwardButton",
                 size: CGSize(width: 150, height: 150),
                 position: CGPoint(x: self.size.width*0.70, y: self.size.height*0.5),
                 zPosition: 2)
        
        addImage(name: "backwardButton",
                 size: CGSize(width: 150, height: 150),
                 position: CGPoint(x: self.size.width*0.30, y: self.size.height*0.5),
                 zPosition: 2)
        
        addImage(name: "closeButton",
                 size: CGSize(width: 150, height: 150),
                 position: CGPoint(x: self.size.width*0.4, y: self.size.height*0.35),
                 zPosition: 2)
        
        addImage(name: "acceptButton",
                 size: CGSize(width: 150, height: 150),
                 position: CGPoint(x: self.size.width*0.6, y: self.size.height*0.35),
                 zPosition: 2)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)
            
            switch nodeTapped[0].name {
            case "forwardButton":
                if let planetImage = self.childNode(withName: planets[currentPlanet]) as? SKSpriteNode {
                    currentPlanet+=1

                    if currentPlanet >= planets.count {
                        currentPlanet=0
                    }
                    
                    setPlanetImage(image: planetImage)
                    
                    let indexOfPlanet =  planets.indexOf(of: planets[currentPlanet])
                    adjustPlanetView(index: indexOfPlanet, image: planetImage)
                }

            case "backwardButton":
                if let planetImage = self.childNode(withName: planets[currentPlanet]) as? SKSpriteNode {
                    currentPlanet-=1
                    if currentPlanet <= -1 {
                        currentPlanet = planets.count-1
                    }
                    setPlanetImage(image: planetImage)

                    
                    let indexOfPlanet =  planets.indexOf(of: planets[currentPlanet])
                    adjustPlanetView(index: indexOfPlanet, image: planetImage)

                }
                
                
            case "acceptButton":
                if let label = self.childNode(withName: "planet") as? SKLabelNode {
                    if label.text == "locked" {
                        
                    } else {
                        let indexOfPlanet =  planets.indexOf(of: planets[currentPlanet])
                        currentEpisode = indexOfPlanet[0]
                        moveToLevelSelectionScene(self)
                    }
                }
                
            case "closeButton":
                moveToMainMenuScene(self)
            default:
            break
            }
        }
    }
    
    

    
    func adjustPlanetView(index indexOfPlanet:[Int], image planetImage:SKSpriteNode) {
        setPlanetText(index: indexOfPlanet)
        setPlanetAlpha(index: indexOfPlanet, image: planetImage)
    }
    
    
    func setPlanetText(index indexOfPlanet:[Int]) {
        if let label = self.childNode(withName: "planet") as? SKLabelNode {
            if indexOfPlanet[0] > record {
                label.text = "locked"
            } else {
                label.text = planets[currentPlanet]
            }
        }
    }
    
    func setPlanetAlpha(index indexOfPlanet:[Int], image planetImage:SKSpriteNode) {
        if indexOfPlanet[0] > record {
            planetImage.alpha = 0.3
        } else {
            planetImage.alpha = 1
        }
    }
    
    
    func setPlanetImage(image planetImage:SKSpriteNode) {
        planetImage.name = planets[currentPlanet]
        planetImage.texture =  SKTexture(imageNamed: planets[currentPlanet])
        
        switch planetImage.name {
        case "mercury": planetImage.setScale(1)
        default: planetImage.setScale(0.7)
        }
    }
    
}
