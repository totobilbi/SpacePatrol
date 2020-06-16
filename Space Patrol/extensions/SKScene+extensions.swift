//
//  SKScene+extensions.swift
//  Space Patrol
//
//  Created by HACKERU on 07/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

extension SKScene {
    
    /*
     add Label to the scene
     */
    func addLabel(text:String, fontSize:CGFloat, fontColor:UIColor, position:CGPoint, zPosition:CGFloat ) {
        let label = SKLabelNode(fontNamed:"theboldfont")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.position = position
        label.zPosition = zPosition
        self.addChild(label)
    }
    
    func addLabel(name:String, text:String, fontSize:CGFloat, fontColor:UIColor, position:CGPoint, zPosition:CGFloat ) {
        let label = SKLabelNode(fontNamed:"theboldfont")
        label.name = name
        label.text = text
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.position = position
        label.zPosition = zPosition
        self.addChild(label)
    }

    
    /*
     add Image to the scene
     */
    func addImage(name:String, scale:CGFloat, position:CGPoint, zPosition:CGFloat) {
        let image = SKSpriteNode(imageNamed: name)
        image.name = name
        image.setScale(scale)
        image.position = position
        image.zPosition = zPosition
        self.addChild(image)
    }
    
    func addImage(name:String, size:CGSize, position:CGPoint, zPosition:CGFloat) {
        let image = SKSpriteNode(imageNamed: name)
        image.name = name
        image.size = size
        image.position = position
        image.zPosition = zPosition
        self.addChild(image)
    }
    
    
    func addImage(imageName:String, name:String, scale:CGFloat, position:CGPoint, zPosition:CGFloat) {
        let image = SKSpriteNode(imageNamed: imageName)
        image.name = name
        image.setScale(scale)
        image.position = position
        image.zPosition = zPosition
        self.addChild(image)
    }
    
    
    func addImage(imageName:String, name:String, size:CGSize, position:CGPoint, zPosition:CGFloat) {
        let image = SKSpriteNode(imageNamed: imageName)
        image.name = name
        image.size = size
        image.position = position
        image.zPosition = zPosition
        self.addChild(image)
    }
    
    
    /*
     add Background to the scene
     */
    func addBackground (imageNamed:String, position:CGPoint, size:CGSize, zPosition:CGFloat) {
        let background = SKSpriteNode(imageNamed: imageNamed)
        background.position = position
        background.size = size
        background.zPosition = zPosition
        self.addChild(background)
    }
    
    
    
    
    func getPresentedViewController() -> UIViewController? {
      var presentViewController = UIApplication.shared.keyWindow?.rootViewController
      while let pVC = presentViewController?.presentedViewController
      {
          presentViewController = pVC
      }

      return presentViewController
    }
    
    
    
    /*
      Move between scenes
     */
      
     func moveToMainMenuScene(_ scene:SKScene) {
         let newScene = MainMenuScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }
     
     
     
     func moveToEpisodeSelectScene(_ scene:SKScene) {
         let newScene = EpisodeSelectScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }
     
     
     func moveToLevelSelectionScene(_ scene:SKScene) {
         let newScene = LevelSelectScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }
     
     
     func moveToLevelDetailsScene(_ scene:SKScene) {
         let newScene = LevelDetailsScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }

     
     func moveToGameScene(_ scene:SKScene) {
         let newScene = GameScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }
     
     
     func moveToGameOverScene(_ scene:SKScene) {
         let newScene = GameOverScene(size: scene.size)
         newScene.scaleMode = scene.scaleMode
         
         let transition  = SKTransition.fade(withDuration: 0.5)
         scene.view!.presentScene(newScene, transition: transition)
     }

}


/*
 index of element in array
 */
extension Array where Element: Equatable {
    func indexOf(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}


