//
//  Bosses.swift
//  Space Patrol
//
//  Created by HACKERU on 09/06/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

class Bosses {
    private init() {}
    static let shared = Bosses()
    
    var currentBoss:[String:Any] = [:]
    
    let gameBosses: [[String:Any]] =
    [
        [
            "bossName": "bossChicken",
            "startPosition": CGPoint(x: screenSize.width*0.5, y: screenSize.height*1.20),
            "screenMovePosition": CGPoint(x: screenSize.width*0.5, y: screenSize.height*0.7),
            "movementPosition":
            [
            CGPoint(x: screenSize.width*0.35, y: screenSize.height*0.7),
            CGPoint(x: screenSize.width*0.65, y: screenSize.height*0.7)
            ],
            "totalHits": 120,
            "rage": 20
        ]
    ]
}
