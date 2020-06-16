//
//  Level.swift
//  Space Patrol
//
//  Created by HACKERU on 08/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import Foundation
import SpriteKit

class Levels {

    private init() {}
    static let shared = Levels()

    var currentLevel:[String:Any] = [:]

    let gameLevels:	[[[String:Any]]] =
    [
        [ // episode 1
            [
            "levelName": "Level 1",
            "levelNumber": 1,
            "levelType": "meteor",
            "livesNumber": 3,
            "numberOfEnemies": 20,
            "enemiesOrder": [
                             smallFireAsteroid, smallFireAsteroid, bigFireAsteroid, smallFireAsteroid, smallFireAsteroid,
                             smallFireAsteroid, smallFireAsteroid, bigFireAsteroid, smallFireAsteroid, smallFireAsteroid,
                             smallFireAsteroid, smallFireAsteroid, bigFireAsteroid, smallFireAsteroid, smallFireAsteroid,
                             smallFireAsteroid, smallFireAsteroid, bigFireAsteroid, smallFireAsteroid, smallFireAsteroid
                            ],
            "fallDuration": [5.0, 5.0, 7.0, 5.0, 5.0,
                             5.0, 5.0, 7.0, 5.0, 5.0,
                             5.0, 5.0, 7.0, 5.0, 5.0,
                             5.0, 5.0, 7.0, 5.0, 5.0],
            "waitDuration": [1.0, 1.0, 1.0, 1.0 ,1.0,
                             1.0, 1.0, 1.0, 1.0 ,1.0,
                             1.0, 1.0, 1.0, 1.0 ,1.0,
                             1.0, 1.0, 1.0, 1.0 ,1.0],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 2",
            "levelNumber": 2,
            "levelType": "chicken",
            "livesNumber": 3,
            "numberOfEnemies": 30,
            "waveSize": [6, 8, 6, 8],
            "enemiesOrder": [
                blueChicken, blueChicken, ballonChicken, ballonChicken, blueChicken, blueChicken,
                ballonChicken, blueChicken, blueChicken, ballonChicken, ballonChicken, blueChicken, blueChicken, ballonChicken,
                blueChicken, blueChicken, ballonChicken, ballonChicken, blueChicken, blueChicken,
                ballonChicken, blueChicken, blueChicken, ballonChicken, ballonChicken, blueChicken, blueChicken, ballonChicken
                ],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 3",
            "levelNumber": 3,
            "levelType": "boss",
            "livesNumber": 3,
            "numberOfEnemies": 1,
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 4",
            "levelNumber": 4,
            "livesNumber": 3,
            "numberOfEnemies": 20,
            "enemiesOrder": ["meteor5", "meteor5", "meteor5", "meteor5"],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ]
        
        ],
        
        [ // episode 2
            [
            "levelName": "Level 1",
            "levelNumber": 1,
            "livesNumber": 3,
            "numberOfEnemies": 5,
            "enemiesOrder": ["metoer5"],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 2",
            "levelNumber": 2,
            "livesNumber": 3,
            "numberOfEnemies": 10,
            "enemiesOrder": ["meteor5", "meteor5"],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 3",
            "levelNumber": 3,
            "livesNumber": 3,
            "numberOfEnemies": 15,
            "enemiesOrder": ["meteor5", "meteor5", "meteor5"],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ],
            
            [
            "levelName": "Level 4",
            "levelNumber": 4,
            "livesNumber": 3,
            "numberOfEnemies": 20,
            "enemiesOrder": ["meteor5", "meteor5", "meteor5", "meteor5"],
            "storyline": "A massive deep-space mining ship goes dark after unearthing a strange artifact on a distant planet. Engineer Isaac Clarke embarks on the repair mission, only to discover the horrible truth about the crew"
            ]
        
        ]
        
        
    ]

    
}

