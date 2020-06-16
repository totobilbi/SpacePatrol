//
//  HealthBar.swift
//  Space Patrol
//
//  Created by HACKERU on 10/06/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit



class HealthBar:SKNode {
    static var currentHealthBar:HealthBar = HealthBar()
    static var reduceAmount:CGFloat = 0
    var bar:SKSpriteNode?
    var barSize:CGSize = CGSize()
    var _progress:CGFloat = 0
    var progress:CGFloat {
        get {
            return _progress
        }
        set {
            let value = max(min(newValue,1.0),0.0)
            if let bar = bar {
                bar.xScale = value
                _progress = value
            }
        }
    }
    
    func changeColor(color:UIColor) {
        bar?.color = color
    }

    convenience init(color:SKColor) {
        self.init()
        barSize = CGSize(width: screenSize.width*0.24, height: screenSize.height*0.03)
        bar = SKSpriteNode(color: color , size: barSize)
        if let bar = bar {
            bar.xScale = 0.0
            bar.zPosition = 100
            bar.position = CGPoint(x: screenSize.width*0.32 ,y: screenSize.height*0.93)
            bar.anchorPoint = CGPoint(x:0.0,y:0.5)
            createHealthBarBackground()
            self.addChild(bar)
            
        }
    }
    
    
    func createHealthBarBackground() {
        let hpBackground = SKShapeNode(rectOf: CGSize(width: screenSize.width*0.35, height: screenSize.height*0.05), cornerRadius: 15)
        hpBackground.zPosition = 98
        hpBackground.position = CGPoint(x: screenSize.width*0.4 ,y: screenSize.height*0.93)
        hpBackground.strokeColor = .black
        hpBackground.fillColor = .purple
        self.addChild(hpBackground)
        
        let hpContainer = SKShapeNode(rectOf: CGSize(width: screenSize.width*0.25, height: screenSize.height*0.04), cornerRadius: 15)
        hpContainer.position = CGPoint(x: screenSize.width*0.44 ,y: screenSize.height*0.93)
        hpContainer.zPosition = 99
        hpContainer.strokeColor = .lightGray
        hpContainer.lineWidth = 2
        self.addChild(hpContainer)
        
        let hpLabel = SKLabelNode(text: "HP")
        hpLabel.horizontalAlignmentMode = .center
        hpLabel.position = CGPoint(x: screenSize.width*0.27 ,y: screenSize.height*0.915)
        hpLabel.fontColor = UIColor.black
        hpLabel.fontName = "theboldfont"
        hpLabel.fontSize = 80
        hpLabel.zPosition = 99
        self.addChild(hpLabel)
    }
}
