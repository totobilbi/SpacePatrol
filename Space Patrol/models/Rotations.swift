//
//  Rotations.swift
//  Space Patrol
//
//  Created by HACKERU on 09/06/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

class Rotations {

private init() {}
static let shared = Rotations()

    let possibleChickenRotations:[[CGPoint]] =
       [
           [CGPoint(x: screenSize.width*0-1, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.3, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.7, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.7, y: screenSize.height*0.5),
            CGPoint(x: screenSize.width*0.3, y: screenSize.height*0.5)
           ],
           
           [CGPoint(x: screenSize.width+1, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.7, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.3, y: screenSize.height*0.8),
            CGPoint(x: screenSize.width*0.3, y: screenSize.height*0.5),
            CGPoint(x: screenSize.width*0.7, y: screenSize.height*0.5)
           ]
       ]
}
