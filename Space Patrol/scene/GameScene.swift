//
//  GameScene.swift
//  Space Patrol
//
//  Created by HACKERU on 05/05/2020.
//  Copyright © 2020 roeico7. All rights reserved.
//

import SpriteKit
import GameplayKit


var levelNumber = 0
var livesNumber = 0
var isGameWon = false
var numberOfEnemies = 0
var screenSize = CGSize()


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
     ██████  ██████   ██████  ██████  ███████ ██████  ████████ ██ ███████ ███████
     ██   ██ ██   ██ ██    ██ ██   ██ ██      ██   ██    ██    ██ ██      ██
     ██████  ██████  ██    ██ ██████  █████   ██████     ██    ██ █████   ███████
     ██      ██   ██ ██    ██ ██      ██      ██   ██    ██    ██ ██           ██
     ██      ██   ██  ██████  ██      ███████ ██   ██    ██    ██ ███████ ███████
    */

    /*
     Game Properties:
     player - player ship node
     levelNumber - indicates the level we are currently playing
     livesNumber - amount of lives on the level
     gameArea - the area within the game is displayed
     gameState - current game state (preGame, inGame, afterGame)
     levelType - the type of the level (meteor, chicken, boss)
     enemyHitCounter - if the enemy requires more than 1 hit, we had him to this array, to count how many hits he received
     possibleChickenRotations - array that holds multiplie arrays of CGPoints that mark a path of movement for the chickens
     eggProtection - is the player protected from eggs

     
     Sound Properties:
     bulletSoundEffect - sound for bullet fire
     explosionSoundEffect - sound for player/enemy explosion
     */

    
    var gameArea = CGRect()

    let tapToStartLabel = SKLabelNode(fontNamed: "theboldfont")
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    let playerTusik = SKSpriteNode(imageNamed: "playerShipTusik")
    
    let bulletSoundEffect = SKAction.playSoundFileNamed("bulletSoundEffect", waitForCompletion: false)
    
    let explosionSoundEffect = SKAction.playSoundFileNamed("explosionSoundEffect", waitForCompletion: false)
    
    var currentGameState = gameState.preGame
    
    var currentLevel:[String:Any] = [:]
    
    var enemyHitCounter:[String:Int] = [:]
    
    var possibleChickenRotations:[[CGPoint]] = [[]]
    
    var levelType:String = ""

    var eggProtection = false
    
    var playerCanShoot = false
    
    var isEnemyBarrierOn = false
    
    var isTouched:Bool = false
   
    
    /*
     Game State:
     preGame - before game started
     inGame - game in progress
     afterGame - game is over
     */
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    

    /*
     Assign a category for each object in the game
     */
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Egg: UInt32 = 0b100
        static let Enemy : UInt32 = 0b1000
        
    }
    

	

    /*
     ██ ███    ██ ██ ████████     ██      ███████ ██    ██ ███████ ██
     ██ ████   ██ ██    ██        ██      ██      ██    ██ ██      ██
     ██ ██ ██  ██ ██    ██        ██      █████   ██    ██ █████   ██
     ██ ██  ██ ██ ██    ██        ██      ██       ██  ██  ██      ██
     ██ ██   ████ ██    ██        ███████ ███████   ████   ███████ ███████

     */

    
    /*
     init the game area
     */
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.width/maxAspectRatio
        let margin = (size.width - playableWidth)/2
        
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
     On view load the following actions occuer:
     - init current level
     - init chicken rotations array
     - init background
     - init playerShip
     - init game score
     - init lives number
     - start level
     */
    override func didMove(to view: SKView) {
        screenSize = self.size
        currentLevel = Levels.shared.currentLevel
        possibleChickenRotations = Rotations.shared.possibleChickenRotations
        livesNumber = currentLevel["livesNumber"] as! Int
        levelNumber = currentLevel["levelNumber"] as! Int
        isGameWon = false
        numberOfEnemies = currentLevel["numberOfEnemies"] as! Int

        self.physicsWorld.contactDelegate = self
        
        initBackground()
        
        initPlayerShip()
        
        initPlayerTusik()
        
        initLives()

        initTapLabel()
    }
    
    
    /*
     Add 2 backgrounds
     */
    func initBackground() {
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "Background"
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            self.addChild(background)
        }
    }
    
    
    
    /*
     Add player ship
     */
    func initPlayerShip() {
        player.setScale(4)
        player.position = CGPoint(x: self.size.width/2, y: -player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
    }
    
    
    
    /*
     Add player tusik
     */
    func initPlayerTusik() {
        playerTusik.setScale(1.2)
        playerTusik.position = CGPoint(x: self.size.width/2, y: -player.size.height)
        playerTusik.zPosition = 2
        self.addChild(playerTusik)
        scaleTusik()
    }
   
    
    
    /*
     Scale player tusik up and down to make animation
     */

    func scaleTusik() {
        let scaleDown = SKAction.scale(to: 1.2, duration: 1.0)
        let scaleUp = SKAction.scale(to: 1.3, duration: 1.0)
        let sequence = SKAction.sequence([scaleDown, scaleUp])
        let scalingAction = SKAction.repeatForever(sequence)
        playerTusik.run(scalingAction, withKey: "playerTusikScale")
    }
    
    
    

    

    /*
     Add lives to the screen
     */
    func initLives() {
        var widthPoint:CGFloat = 0.77
        for i in 0..<livesNumber {
            addImage(imageName: "livesIcon",
                     name: "life\(i)",
                    size: CGSize(width: self.size.width*0.08, height: self.size.height*0.08),
                     position: CGPoint(x: self.size.width*widthPoint, y: self.size.height*0.93),
                     zPosition: 100)
            widthPoint-=0.07
        }
        
        hideLifeUI(0)
    }
    
    

    
    /*
     Add tap to start label
     */
    func initTapLabel() {
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }
    
    
    
    /*
     Moves the game from preGame state to inGame state
     - fade "TAP TO BEGIN" label and delete it
     - move player ship into screen and start level
     */
    func startGame() {
        currentGameState = .inGame
        playerCanShoot = true
        var sequence:SKAction
        
        //fade label and delete it
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        sequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(sequence)
        
        //move ship to screen and start level
        let moveShip = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let moveShipTusik = SKAction.moveTo(y: self.size.height*0.2-player.size.height*1.2, duration: 0.5)
        let startLevel = SKAction.run(startNewLevel)
        player.run(moveShip)
        playerTusik.run(moveShipTusik) {
            self.run(startLevel)
        }
    }
    
    
    
    /*
     Starts the level:
     - spawn level enemies
     */
    
    func startNewLevel() {
        levelType = currentLevel["levelType"] as! String

        switch levelType {
        case "meteor": spawnMeteors()
        case "chicken": spawnChickens()
        case "boss": spawnBoss()
        default: break
        }
    }
    
    
    
    /*
     ██    ██ ██████  ██████   █████  ████████ ███████
     ██    ██ ██   ██ ██   ██ ██   ██    ██    ██
     ██    ██ ██████  ██   ██ ███████    ██    █████
     ██    ██ ██      ██   ██ ██   ██    ██    ██
      ██████  ██      ██████  ██   ██    ██    ███████

     
     ███████ ██████   █████  ███    ███ ███████ ███████
     ██      ██   ██ ██   ██ ████  ████ ██      ██
     █████   ██████  ███████ ██ ████ ██ █████   ███████
     ██      ██   ██ ██   ██ ██  ██  ██ ██           ██
     ██      ██   ██ ██   ██ ██      ██ ███████ ███████
     */
    
    //last frame update time
    var lastUpdateTime:TimeInterval = 0
    
    //time passed between frame update time
    var timePassed:TimeInterval = 0
    
    //amount of points to move background per second
    var amountToMove:CGFloat = 600.0
    
    //touch timer
    var longTouchTimer:TimeInterval = 0

    //Move background once per frame
    override func update(_ currentTime: TimeInterval) {
        //if boss barrier is on, make it follow the boss
        if isEnemyBarrierOn {
            let barrier = self.childNode(withName: "barrier")
            barrier?.position = boss.position
        }
        
        //get update time initialized
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            timePassed = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        
        //fire bullet if screen is touched
        //animate the ship movment
        longTouchTimer += timePassed
        if isTouched && longTouchTimer > 0.3 && playerCanShoot {
            longTouchTimer = 0
            fireBullet()
        }
        
    
        playerShipAnimation(dragDirection)
        
        
        

        
        //amount of points to move depneding on the time passed
        let amountToMoveBackground = amountToMove * CGFloat(timePassed)
        
        //get both of the backgrounds
        self.enumerateChildNodes(withName: "Background") { (background, stop) in
            
            if self.currentGameState == .inGame || (self.currentGameState == .afterGame && isGameWon) {
                //move the backgrounds according to the amount
                background.position.y -= amountToMoveBackground
            }
            
            //if the background moves below the screen -> move it to the top
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
            
        }
        
        // check if chicken wave is defeated
        // if it is summon next wave / game win
        if levelType == "chicken" {
            if chickenToKill == 0 && currentWave < amountOfWaves {
                currentWave += 1
                if amountOfWaves == currentWave {
                    gameWon()
                } else {
                    spawnChickens()
                }
            }
        }
    }
    
    
    
    
    
    /*
      ██████  ██████  ███    ██ ████████  █████   ██████ ████████
     ██      ██    ██ ████   ██    ██    ██   ██ ██         ██
     ██      ██    ██ ██ ██  ██    ██    ███████ ██         ██
     ██      ██    ██ ██  ██ ██    ██    ██   ██ ██         ██
      ██████  ██████  ██   ████    ██    ██   ██  ██████    ██
     */


    /*
    Contact between bodies:
    bullet && enemy = remove both + enemy explosion / bullet hit + (add score)?
    player && enemy = remove both and playerTusik + player explosion + enemy explosion + game over
    player && egg = remove both + player explosion + lose ife + respawn player
    */
       
    func didBegin(_ contact: SKPhysicsContact) {
       var body1 = SKPhysicsBody()
       var body2 = SKPhysicsBody()
       
       if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
           body1 = contact.bodyA
           body2 = contact.bodyB
       } else {
           body1 = contact.bodyB
           body2 = contact.bodyA
       }
       
       if body1.categoryBitMask == PhysicsCategories.Player
        && (body2.categoryBitMask == PhysicsCategories.Enemy) {
           // if the enemy hit the player
            meteorHitPlayer(body1, body2)
        }

        if body1.categoryBitMask == PhysicsCategories.Player
            && (body2.categoryBitMask == PhysicsCategories.Egg) {
            //if the egg hit the player
            eggHitPlayer(body1, body2)
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet
        && body2.categoryBitMask == PhysicsCategories.Enemy
        && body2.node?.position.y ?? self.size.height < self.size.height {
           // if the bullet hit the enemy
            bulletHitEnemy(body1, body2)
        }
    }

    
    /*
     Meteor hit player:
     -Explode both
     - GameOver
     */
    func meteorHitPlayer(_ body1:SKPhysicsBody, _ body2:SKPhysicsBody) {
            explodeBody(body1)
            explodeBody(body2)
            playerTusik.removeFromParent()
            livesNumber = 0
            gameOver()
    }
       
    
    
    /*
     Egg hit player:
     - Explode player
     - Remove egg
     - Respawn player
     */
    func eggHitPlayer(_ body1:SKPhysicsBody, _ body2:SKPhysicsBody) {
        body2.node?.removeFromParent()
        if !eggProtection {
            playerCanShoot = false
            explodeBody(body1)
            playerTusik.removeFromParent()
            respawnPlayer()
        }
    }
    
    
    /*
     Bullet hit enemy:
     if enemy HP is bigger than 1 -> remove bullet, spawn hit effect, update enemy hit count
     if enemy HP is 1 -> remove bullet, remove enemy, spawn explosion effect, add score
     */
    func bulletHitEnemy(_ body1:SKPhysicsBody, _ body2:SKPhysicsBody) {
        if body2.node != nil {
            if !isEnemyBarrierOn {
                // get enemy name (example: "meteor-UUID")
                guard let enemyName = body2.node?.name
                    else {return}
                
                //get enemy type (example: "weakBlueChicken", "bossChicken")
                let enemyType = enemyName.substring(to: enemyName.firstIndex(of:"-")!)
                
                //check if enemy requires more than 1 hit
                if !enemyType.contains("weak") {
                    //if enemy has been hit before
                    if enemyHitCounter[enemyName] != nil {
                        enemyHitCounter[enemyName] = enemyHitCounter[enemyName]! + 1
                        
                        //if enemy got hit enough times to die
                        if getEnemyRequiredHitCount(enemyType) == enemyHitCounter[enemyName] {
                             defeatEnemy(enemyType, body2)
                        } else {
                            spawnBulletHit(spawnPosition: body2.node!.position)
                            if enemyType.contains("Ballon") {
                                replaceBallonChicken(enemyName, enemyHitCounter[enemyName]!)
                            }
                        }
                      
                    //first bullet hit on enemy with more than 1 HP
                    } else {
                        // start counting bullet hits on that enemy
                        // show bullet hit effect
                        enemyHitCounter[enemyName] = 1
                        spawnBulletHit(spawnPosition: body2.node!.position)
                        if enemyType.contains("Ballon") {
                            replaceBallonChicken(enemyName, enemyHitCounter[enemyName]!)
                        }
                    }
                    
                    //if this is boss level
                    if enemyType.contains("boss") {
                        //reduce boss HP
                        reduceBossHP()
                        
                        //if total hits divided by hits for boss rage are 0
                        // boss rage
                        if (enemyHitCounter[enemyName]!)%(Bosses.shared.currentBoss["rage"] as! Int) == 0 && (enemyHitCounter[enemyName]!) != getBossHitCount() {
                            bossRage()
                        }
                    }


                    
                // enemy requires 1 hit to die
                } else {
                    defeatEnemy(enemyType, body2)
                }
                
            //enemy barrier is up, bullet is not effective
            } else {
                if let barrier = self.childNode(withName: "barrier") {
                    spawnEnemyBarrierHit(spawnPosition: barrier.position)
                }
            }
            //remove bullet from scene
            body1.node?.removeFromParent()
        }
    }
    
    

    
    /*
     Spawn explosion
     (if enemy is chicken type, remove the amount needed to complete the wave)
     */
    func defeatEnemy(_ enemyType:String, _ body:SKPhysicsBody) {
        if enemyType.contains("Chicken") {
            chickenToKill -= 1
        }
        explodeBody(body)
    }

    
    /*
      Spawns explosion
      Remove body node from scene
     */
    func explodeBody(_ body:SKPhysicsBody) {
        if body.node != nil {
            spawnExplosion(spawnPosition: body.node!.position)
            body.node?.removeFromParent()
        }
    }
    
    
       
       /*
        Spawns explosion on a certain point
        */
    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)


        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSoundEffect ,scaleIn, fadeOut, delete])
       
        explosion.run(explosionSequence)
       }
       
       
       /*
        Spawns bullet hit mark on a certain point
        */
       func spawnBulletHit(spawnPosition: CGPoint) {
           let bulletHit = SKSpriteNode(imageNamed: "bulletHit")
           bulletHit.position = spawnPosition
           bulletHit.zPosition = 3
           bulletHit.setScale(3)
           self.addChild(bulletHit)
           
           let scaleIn = SKAction.scale(to: 1, duration: 0.1)
           let fadeOut = SKAction.fadeOut(withDuration: 0.1)
           let delete = SKAction.removeFromParent()
           
           let bulletHitSequence = SKAction.sequence([bulletSoundEffect ,scaleIn, fadeOut, delete])
           
          bulletHit.run(bulletHitSequence)
       }
       
    
    
    /*
     Spawns bullet hit mark on enemy barrier
     */
    func spawnEnemyBarrierHit(spawnPosition: CGPoint) {
        if let barrier = self.childNode(withName: "barrier") as? SKSpriteNode {
            let bulletHit = SKSpriteNode(imageNamed: "barrierHit")
            bulletHit.position = CGPoint(x: spawnPosition.x, y: spawnPosition.y-barrier.size.height/2)
            bulletHit.zPosition = 3
            bulletHit.setScale(1)
            self.addChild(bulletHit)
             
            let scaleIn = SKAction.scale(to: 1, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let delete = SKAction.removeFromParent()
             
            let bulletHitSequence = SKAction.sequence([bulletSoundEffect ,scaleIn, fadeOut, delete])
             
            bulletHit.run(bulletHitSequence)
        }
    }
    
    
    /*
    Returns the requird amount of shots to eliminate enemy according to his type
    */
    func getEnemyRequiredHitCount(_ enemyType:String) -> Int {
        if enemyType.contains("boss") {
             return getBossHitCount()
        } else if enemyType.contains("medium") {
            return 5
        } else if enemyType.contains("strong") {
            return 10
        }
        return 1
    }
    
    
    /*
     Returns current boss hit count
     */
    func getBossHitCount() -> Int {
        return Bosses.shared.gameBosses[currentEpisode]["totalHits"] as! Int
    }
    
    
    
    
    
    
    /*
     ███████ ██████   █████  ██     ██ ███    ██
     ██      ██   ██ ██   ██ ██     ██ ████   ██
     ███████ ██████  ███████ ██  █  ██ ██ ██  ██
          ██ ██      ██   ██ ██ ███ ██ ██  ██ ██
     ███████ ██      ██   ██  ███ ███  ██   ████
     */
    
    
    
    
    var currentWave = 0
    var currentSpawnIndex = 0
    var chickenToKill = 99
    var amountOfWaves = 0
    var randomRotationIndex = 0
    var enemyOrder:[String] = []
    
    
    /*
     Respawns the player
     Grans egg protection for 1.5 seconds
     */
    
    func respawnPlayer() {
        eggProtection = true
        loseLife()
        
        if livesNumber>0 {
            initPlayerShip()
            initPlayerTusik()
            scaleTusik()
            player.alpha = 0.5
            playerTusik.alpha = 0.5
            
            let moveShip = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
            let moveShipTusik = SKAction.moveTo(y: self.size.height*0.2-player.size.height, duration: 0.5)
            let coolDown = SKAction.wait(forDuration: 1.5)
            let removeEggProtection = SKAction.run{
                self.eggProtection = false
                self.player.alpha = 1
                self.playerTusik.alpha = 1
                self.playerCanShoot = true
            }
            
            player.run(SKAction.sequence([coolDown, moveShip, coolDown, removeEggProtection]))
            playerTusik.run(SKAction.sequence([coolDown, moveShipTusik]))
        }
    }
    
    
    
    /*
     Generate random point to spawn meteor
     */
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    
    /*
     Create enemy node
     */
    func createEnemy(_ enemyName:String, _ startPoint:CGPoint) -> SKSpriteNode {
        let enemy = SKSpriteNode(imageNamed: enemyName)
        enemy.name = "\(enemyName)-\(UUID().uuidString)"
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        return enemy
    }
    
    
    
    /*
     Create egg node
     */
    func createEgg(_ chickenPosition:CGPoint) -> SKSpriteNode {
        let egg = SKSpriteNode(imageNamed: "enemyEgg")
        egg.name = "enemyEgg-\(UUID().uuidString)"
        egg.position = chickenPosition
        egg.zPosition = 1
        egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
        egg.physicsBody?.affectedByGravity = false
        egg.physicsBody?.categoryBitMask = PhysicsCategories.Egg
        egg.physicsBody?.collisionBitMask = PhysicsCategories.None
        egg.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        return egg
    }
    
    /*
        Spawns current level meteors
        According to enemy order, wait duration and fall duration
    */
       func spawnMeteors() {
           showLifeUI()
           let fallDurationOrder = currentLevel["fallDuration"] as! [TimeInterval]
           let waitDurationOrder = currentLevel["waitDuration"] as! [TimeInterval]
           enemyOrder = currentLevel["enemiesOrder"] as! [String]
           var actionsArray:[SKAction] = []
           
           for index in 0..<numberOfEnemies {
               let enemyToSpawn = SKAction.run {
                self.spawnMeteor(self.enemyOrder[index], fallDurationOrder[index])
               }
               actionsArray.append(SKAction.wait(forDuration: waitDurationOrder[index]))
               actionsArray.append(enemyToSpawn)
           }
             actionsArray.append(SKAction.wait(forDuration: fallDurationOrder[fallDurationOrder.count-1]))
             actionsArray.append(SKAction.run(gameWon))
           let spawnSequence = SKAction.sequence(actionsArray)
           self.run(spawnSequence)
       }
      
      
    
    /*
     Spawn meteor at random X location above the screen
     and move it below the screen in random angle
     */
    func spawnMeteor(_ enemyName:String, _ fallDuration:TimeInterval) {
        if currentGameState == gameState.inGame {
            let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
            let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
            
            let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
            let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
            
            let enemy = createEnemy(enemyName, startPoint)
            enemy.setScale(4)
            self.addChild(enemy)
            
            meteorAnimation(enemy)
            
            let moveEnemy = SKAction.move(to: endPoint, duration: fallDuration)
            let deleteEnemy = SKAction.removeFromParent()
            let loseLife = SKAction.run(self.loseLife)
            let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseLife])
            enemy.run(enemySequence)
            
            let dx = endPoint.x - startPoint.x
            let dy = endPoint.y - startPoint.y
            
            let amountToRotate = atan2(dy, dx)
            
            enemy.zRotation = amountToRotate
        }
    }
    
    /*
        Spawns current level chickens
        According to enemy order, wave size and amount of waves
    */
    
     func spawnChickens() {
        showLifeUI()
         enemyOrder = currentLevel["enemiesOrder"] as! [String]
         let waveSize = currentLevel["waveSize"] as! [Int]
         chickenToKill = waveSize[currentWave]
         amountOfWaves = waveSize.count
         var actionsArray:[SKAction] = []
         randomRotationIndex = Int.random(in: 0..<possibleChickenRotations.count)
         
         for _ in 0..<waveSize[currentWave] {
             let enemyToSpawn = SKAction.run(spawnChicken)
             actionsArray.append(SKAction.wait(forDuration: 1))
             actionsArray.append(enemyToSpawn)
         }
         
         let spawnSequence = SKAction.sequence(actionsArray)
         self.run(spawnSequence)
     }
     
     
     
     /*
      Spawn chicken at outside of the screen
      and moves it in random chosen movement pattern
      */
     func spawnChicken() {
         if currentGameState == gameState.inGame {
            let enemyName = enemyOrder[currentSpawnIndex]
            let currentRotation = possibleChickenRotations[randomRotationIndex]
            let startPoint:CGPoint = currentRotation[0]
             
            let enemy = createEnemy(enemyName, startPoint)
            
            enemy.setScale(4)
            
            self.addChild(enemy)

            if !enemyName.contains("Ballon") {
                flyingAnimation(enemy)
            }
            
            var actionsArray:[SKAction] = []
            for pointIndex in 1..<currentRotation.count {
                actionsArray.append(SKAction.move(to: currentRotation[pointIndex], duration: 2.0))
            }
             
            let enemySequence = SKAction.sequence(actionsArray)
            let enemyMovement = SKAction.repeatForever(enemySequence)
            let startAction = SKAction.move(to: startPoint, duration: 2.0)
            
            let eggWait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 1..<7)))
            let eggAction = SKAction.run {
                self.spawnChickenEgg(enemy.position)
            }
            let dropSequence = SKAction.sequence([eggWait, eggAction])
            let dropEgg = SKAction.repeatForever(dropSequence)
            
            enemy.run(startAction) {
                enemy.run(enemyMovement)
                enemy.run(dropEgg)

            }
            currentSpawnIndex += 1
         }
     }
     
    
     /*
      Makes the chicken shit some eggs
      */
     func spawnChickenEgg(_ chickenPosition:CGPoint) {
         if chickenPosition.x < self.size.width && chickenPosition.x > self.size.width*0 {
             let egg = createEgg(chickenPosition)
             self.addChild(egg)
             
             let moveEgg = SKAction.move(to: CGPoint(x: chickenPosition.x, y: self.size.height*0-1), duration: 6.0)
             let deleteEgg = SKAction.removeFromParent()
             let eggSequence = SKAction.sequence([moveEgg, deleteEgg])
             egg.run(eggSequence)
         }
     }
    
    
    var boss:SKSpriteNode = SKSpriteNode()
    /*
     Spawns massive fat a.s.s boss
     */
    func spawnBoss() {
        playerCanShoot = false
        //load boss info
        let bossInfo = Bosses.shared.gameBosses[currentEpisode]
        Bosses.shared.currentBoss = bossInfo
        let bossName = bossInfo["bossName"] as! String
        let startPoint = bossInfo["startPosition"] as! CGPoint

        //create boss
        boss = createEnemy(bossName, startPoint)
        boss.setScale(1.3)
        self.addChild(boss)
        
        flyingAnimation(boss)
        
        //get boss movement pattern
        let bossMovement = bossInfo["movementPosition"] as! [CGPoint]
        let repeatMovement = generateBossMovement(boss, bossMovement)
        
        //move boss to screen
        let screenPoint = bossInfo["screenMovePosition"] as! CGPoint
        let moveAction = SKAction.move(to: screenPoint, duration: 5.0)

        //get the egg drop pattern
        let dropEgg = generateBossEggPattern(boss)
    
        boss.run(moveAction) {
            self.showLifeUI()
            self.createBossHPBar()
            self.playerCanShoot = true
            self.boss.run(repeatMovement)
            self.boss.run(dropEgg)
        }
     }
    
    /*/
     Init boss helath bar
     */
    func createBossHPBar() {
        let healthBar =  HealthBar(color: SKColor.green)
        healthBar.name = "healthBar"
        healthBar.alpha = 0
        addChild(healthBar)
        healthBar.progress = 1
        HealthBar.currentHealthBar = healthBar
        HealthBar.reduceAmount = CGFloat(1.0/Double(getBossHitCount()))
        showHealthBar()
    }
    
    
    
    /*
     Moves boss around the screen according to his pattern
     */
    func generateBossMovement(_ boss:SKSpriteNode, _ bossMovement:[CGPoint]) -> SKAction {
        //make movment SKactions array
        var actionsArray:[SKAction] = []
        for moveIndex in 0..<bossMovement.count {
            actionsArray.append(SKAction.move(to: bossMovement[moveIndex], duration: 5.0))
        }
                    
        //create sequence and repat forever
        let movementSequence = SKAction.sequence(actionsArray)
        let repeatMovement = SKAction.repeatForever(movementSequence)
        
        return repeatMovement
    }
    
    
    
    /*
     Create egg pattern for the boss
     */
    func generateBossEggPattern(_ boss:SKSpriteNode) -> SKAction {
        let eggWait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 2..<5)))
        let eggAction = SKAction.run {
            self.spawnBossEggs(boss.position)
        }
        let dropSequence = SKAction.sequence([eggWait, eggAction])
        let dropEgg = SKAction.repeatForever(dropSequence)
        
        return dropEgg
    }
    
    
    
    /*
     Spawn 3 eggs and move them down
     When it reaches the end remove the from screen
     */
    func spawnBossEggs(_ bossPosition:CGPoint) {
        if bossPosition.x < self.size.width && bossPosition.x > self.size.width*0 {
            let eggs =
            [
                createEgg(CGPoint(x: bossPosition.x*0.8, y: bossPosition.y*0.85)),
                createEgg(CGPoint(x: bossPosition.x, y: bossPosition.y*0.85)),
                createEgg(CGPoint(x: bossPosition.x*1.2, y: bossPosition.y*0.85))
            ]
            let moveEgg = SKAction.moveTo(y: self.size.height*0-1, duration: 6.0)
            let deleteEgg = SKAction.removeFromParent()
            let eggSequence = SKAction.sequence([moveEgg, deleteEgg])
            
            for egg in eggs {
                self.addChild(egg)
                egg.run(eggSequence)
            }
        }
    }
    
    
    /*
     Action that the boss does after being damaged a few times
     */
    func bossRage() {
        let addBarrier = SKAction.run(addEnemyBarrier)
        let duration = SKAction.wait(forDuration: 5)
        let removeBarrier = SKAction.run(removeEnemyBarrier)
        
        let rageSequence = SKAction.sequence([addBarrier, duration, removeBarrier])
        self.run(rageSequence)
    }
    
    
    /*
     Add barrier to boss
     */
    func addEnemyBarrier() {
        let barrier = SKSpriteNode(imageNamed: "barrier")
        barrier.setScale(1.8)
        barrier.name = "barrier"
        barrier.position = boss.position
        barrier.zPosition = boss.zPosition+1
        self.addChild(barrier)
        
        isEnemyBarrierOn = true
    }
    
    
    /*
     Remove barrier from scene
     */
    func removeEnemyBarrier() {
        let barrier = self.childNode(withName: "barrier")
        barrier?.run(SKAction.fadeOut(withDuration: 0.5))
        barrier?.removeFromParent()
        
        isEnemyBarrierOn = false
    }
    
    /*
     Lower boss HP bar every hit
     If health below 50% -> change color to yellow
     If health below 20% -> change color to red
     If boss health is 0 -> win game
     */
    func reduceBossHP() {
        HealthBar.currentHealthBar.progress -= HealthBar.reduceAmount
        
        if HealthBar.currentHealthBar.progress < 0.2  {
            HealthBar.currentHealthBar.changeColor(color: UIColor.red)
        } else if HealthBar.currentHealthBar.progress < 0.5 {
            HealthBar.currentHealthBar.changeColor(color: UIColor.yellow)
        }
        
        if HealthBar.currentHealthBar.progress < HealthBar.reduceAmount  {
            self.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                        SKAction.run(hideBossUI),
                                        SKAction.run(gameWon)]))
        }
    }
    
    
    func replaceBallonChicken(_ nodeName:String, _ index:Int) {
        let node = self.childNode(withName: nodeName) as? SKSpriteNode
        let enemyName = nodeName.substring(to: nodeName.firstIndex(of:"-")!)
        node?.texture = SKTexture.init(imageNamed: "\(enemyName)\(index)")
    }

    
    /*
     ████████  ██████  ██    ██  ██████ ██   ██
        ██    ██    ██ ██    ██ ██      ██   ██
        ██    ██    ██ ██    ██ ██      ███████
        ██    ██    ██ ██    ██ ██      ██   ██
        ██     ██████   ██████   ██████ ██   ██
     */
    
    
    /*
        Fire a Bullet from playerShip X location to top of screen
        */
       
       func fireBullet() {
           let bullet = SKSpriteNode(imageNamed: "bullet")
           bullet.name = "Bullet"
           bullet.setScale(0.4)
           bullet.position = player.position
           bullet.zPosition = 1
           bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
           bullet.physicsBody?.affectedByGravity = false
           bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
           bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
           bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
           self.addChild(bullet)
           
           let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
           
           let deleteBullet = SKAction.removeFromParent()
           
           let bulletSequence = SKAction.sequence([bulletSoundEffect, moveBullet, deleteBullet])
           
           bullet.run(bulletSequence)
       }
    

    
    /*
      preGame - starts the game on screen touch
      inGame - Fires a bullet on screen touch
      */
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         if currentGameState == .preGame {
             startGame()
         }
         
         else if currentGameState == .inGame && playerCanShoot {
            isTouched = true
         }
     }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = false
    }
     
     
     
    var dragDirection:String = "none"
     /*
      Move the player left and right
      */
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         for touch: AnyObject in touches {
                if currentGameState == gameState.inGame {
                let pointOfTouch = touch.location(in: self)
                 
                let previousPointOfTouch = touch.previousLocation(in: self)
                 
                let amountDragged = pointOfTouch.x - previousPointOfTouch.x
                    
                if amountDragged > 0 {
                    dragDirection = "right"
                } else if amountDragged < 0 {
                    dragDirection = "left"
                }
                 
                if player.position.x + amountDragged > gameArea.maxX {
                    player.position.x = gameArea.maxX
                    playerTusik.position.x = gameArea.maxX
                } else if player.position.x + amountDragged < gameArea.minX {
                    player.position.x = gameArea.minX
                    playerTusik.position.x = gameArea.minX
                } else {
                    player.position.x += amountDragged
                    playerTusik.position.x += amountDragged
                }
            }
        }
        
     }
    
    
    
    
    /*
      ██████  ███████ ███    ██ ███████ ██████   █████  ██
     ██       ██      ████   ██ ██      ██   ██ ██   ██ ██
     ██   ███ █████   ██ ██  ██ █████   ██████  ███████ ██
     ██    ██ ██      ██  ██ ██ ██      ██   ██ ██   ██ ██
      ██████  ███████ ██   ████ ███████ ██   ██ ██   ██ ███████
     */
    

    
    /*
     - lower lives number
     - game over if lives number is 0
     */
    
    func loseLife() {
        livesNumber -= 1
        let lifeNode = self.childNode(withName: "life\(livesNumber)")
        lifeNode?.run(SKAction.fadeOut(withDuration: 1.0)) {
            lifeNode?.removeFromParent()
        }
        
        if livesNumber == 0 {
            gameOver()
        }
    }
    
    
    /*
     Hide all the UI in a boss level
     */
    func hideBossUI() {
        hideLifeUI(0.5)
        hideHealthBar()
    }

    
    /*
     Hide player life UI
     */
    func hideLifeUI(_ duration:TimeInterval) {
        for livesNum in 0..<livesNumber {
            let lifeNode = self.childNode(withName: "life\(livesNum)")
            lifeNode?.run(SKAction.fadeOut(withDuration: duration))
        }
    }
    
    
    /*
     Show player life UI
     */
    func showLifeUI() {
        for livesNum in 0..<livesNumber {
            let lifeNode = self.childNode(withName: "life\(livesNum)")
            lifeNode?.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    
    /*
     Hide boss healthbar UI
     */
    func hideHealthBar() {
        let healthBar = self.childNode(withName: "healthBar")
        healthBar?.run(SKAction.fadeOut(withDuration: 0.5))
    }
    
    
    /*
     Show boss healthbar UI
     */
    func showHealthBar() {
        let healthBar = self.childNode(withName: "healthBar")
        healthBar?.run(SKAction.fadeIn(withDuration: 0.5))
    }
    



    

    
    /*
     
      █████  ███    ██ ██ ███    ███  █████  ████████ ██  ██████  ███    ██
     ██   ██ ████   ██ ██ ████  ████ ██   ██    ██    ██ ██    ██ ████   ██
     ███████ ██ ██  ██ ██ ██ ████ ██ ███████    ██    ██ ██    ██ ██ ██  ██
     ██   ██ ██  ██ ██ ██ ██  ██  ██ ██   ██    ██    ██ ██    ██ ██  ██ ██
     ██   ██ ██   ████ ██ ██      ██ ██   ██    ██    ██  ██████  ██   ████
     */
    
    
    
    /*
     Make the meteor rotation animation
     */
    func meteorAnimation(_ node:SKSpriteNode) {
        let nodeName = node.name ?? ""
        let textureName = nodeName.substring(to: nodeName.firstIndex(of:"-")!)
        
        let min = 0
        let max = 32
        var frames: [SKTexture] = []

        for i in min..<max {
            frames.append(SKTexture.init(imageNamed: "\(textureName)\(i)"))
        }

        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
        node.run(SKAction.repeatForever(animation))
    }
    
    
    
    
    
    /*
     Make the chicken fly animation
     */
    func flyingAnimation(_ node:SKSpriteNode) {
        let nodeName = node.name ?? ""
        let textureName = nodeName.substring(to: nodeName.firstIndex(of:"-")!)
    
        let min = 0
        let max = 10
        var frames: [SKTexture] = []

        for i in min..<max {
            frames.append(SKTexture.init(imageNamed: "\(textureName)\(i)"))
        }
        
        for i in stride(from: max-1, to: min, by: -1) {
             frames.append(SKTexture.init(imageNamed: "\(textureName)\(i)"))
        }
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
        node.run(SKAction.repeatForever(animation))
    }
    
    
    
    /*
     Change playerShip texture accoridng to fly direction
     */
    func playerShipAnimation(_ direction:String) {
        if dragDirection != "none" {
            let textureName = "playerShip"
            var frames: [SKTexture] = []
            
            frames.append(SKTexture(imageNamed: "\(textureName)_\(direction)"))
            frames.append(SKTexture(imageNamed: textureName))
            dragDirection = "none"

            let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
            player.run(animation)
        }
    }
    
    
    
    
    /*
     ███████ ███    ██ ██████       ██████   █████  ███    ███ ███████
     ██      ████   ██ ██   ██     ██       ██   ██ ████  ████ ██
     █████   ██ ██  ██ ██   ██     ██   ███ ███████ ██ ████ ██ █████
     ██      ██  ██ ██ ██   ██     ██    ██ ██   ██ ██  ██  ██ ██
     ███████ ██   ████ ██████       ██████  ██   ██ ██      ██ ███████
     */
    
    
    /*
     Runs only when game is won
     Begins end game actions
     */
    func gameWon() {
        isGameWon = true
        gameOver()
    }
    
    
    /*
     End of level animation
     */
    func endGameAnimation() {
        let chatBubble = SKSpriteNode(imageNamed: "chatBubble")
        let messageLabel = SKLabelNode(fontNamed: "theboldfont")
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        
        //move ship to middle
        var waitAction = SKAction.wait(forDuration: 1.0)
        var moveShip = SKAction.moveTo(x: self.size.width/2, duration: 1.0)
        var sequence = SKAction.sequence([moveShip, waitAction])
        player.run(sequence)
        playerTusik.run(sequence) {
            
            //show game end bubble
            chatBubble.setScale(0.45)
            chatBubble.position = CGPoint(x: self.size.width*0.4, y: self.size.height*0.22+self.player.size.height)
            chatBubble.zPosition = 2
            chatBubble.alpha = 0
            self.addChild(chatBubble)
            
            //display message on the bubble
            messageLabel.text = "Good Job!"
            messageLabel.fontSize = 40
            messageLabel.fontColor = SKColor.white
            messageLabel.position = chatBubble.position
            messageLabel.alpha = 0
            messageLabel.zPosition = 3
            self.addChild(messageLabel)
            
            //fade bubble and message into screen
            waitAction = SKAction.wait(forDuration: 3.0)
            sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction])
            messageLabel.run(sequence)
            chatBubble.run(sequence) {
                
                //move ship above screen
                waitAction = SKAction.wait(forDuration: 2.0)
                moveShip = SKAction.moveTo(y: self.size.height*1.4, duration: 2.0)
                sequence = SKAction.sequence([moveShip, waitAction])
                self.player.run(sequence)
                
                //move tusik above screen
                moveShip = SKAction.moveTo(y: self.size.height*1.4-self.player.size.height, duration: 2.0)
                sequence = SKAction.sequence([moveShip, waitAction])
                self.playerTusik.run(sequence) {
                    //move to game over scene on animation complete
                    self.run(SKAction.run(self.gameOverScene))
                }
            }
        }
    }

    
    
    
    /*
     Game Over:
     - stop all bullets
     - show end game animation (if game is won)
     - show game over screen
     */
    func gameOver() {
        currentGameState = .afterGame
        

        self.enumerateChildNodes(withName: "Bullet") { (bullet, stop) in
            bullet.removeAllActions()
            bullet.removeFromParent()
        }
        

        if isGameWon {
            endGameAnimation()
        } else {
            let changeSceneAction = SKAction.run(gameOverScene)
            let delay = SKAction.wait(forDuration: 1)
            let changeSceneSequence = SKAction.sequence([delay, changeSceneAction])
            self.run(changeSceneSequence)
        }
        
    }
    

    /*
     Change scene to game over scene
     */
    func gameOverScene() {
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = self.scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(gameOverScene, transition: transition)
    }
}
