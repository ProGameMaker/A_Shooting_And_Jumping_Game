//
//  GameScene.swift
//  Re_StartGame
//
//  Created by Nguyễn Trí on 12/2/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monster   : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
    }
    
    class mySpriteNode: SKSpriteNode {
        
        var health : Int32 = 1
    }
    
    @objc let swipeUpRec = UISwipeGestureRecognizer()
    var background = SKSpriteNode()
    var mainChar = mySpriteNode()
    var bullet = mySpriteNode()
    var ostacle = mySpriteNode()
    var number = SKLabelNode();
    var Score = SKLabelNode();
    
    var runningFrame: [SKTexture] = []
    var jumppingFram: [SKTexture] = []
    var shootingFram: [SKTexture] = []
    var obstacleFram: [SKTexture] = []
    var health: [SKSpriteNode] = []
    
    var IsEnable = false
    var IsCollide = false
    var IsReset = false
    var IsTouch = false
    var score = 0
    var bull = 20
    var recognizer = UIGestureRecognizer()
    
    func builAnimation(animationFile: String) -> [SKTexture] {
        
        let AnimatedAtlas = SKTextureAtlas(named: animationFile)
        var Frames: [SKTexture] = []
        
        let numImages = AnimatedAtlas.textureNames.count
         for i in 0...numImages - 1 {
            let TextureName = "\(animationFile)_\(i)"
            Frames.append(AnimatedAtlas.textureNamed(TextureName))
        }
        
        return Frames
    }
    
    func CreateChar() {
        
        let charTexture = SKTexture(imageNamed: "Runn_0")
        mainChar = mySpriteNode(texture: charTexture)
        
        mainChar.size = CGSize(width: self.mainChar.size.width/7, height: self.mainChar.size.height/7)
        mainChar.position = CGPoint(x: ((scene?.size.width)!)/7,y: (scene?.size.height)!/3.6)
        mainChar.health = 5
        
        // set main char physic body
        mainChar.physicsBody = SKPhysicsBody(texture: mainChar.texture!, size: mainChar.frame.size)
        mainChar.physicsBody?.isDynamic = true
        mainChar.physicsBody?.allowsRotation = false
        mainChar.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        mainChar.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        mainChar.physicsBody?.collisionBitMask = PhysicsCategory.none
        mainChar.physicsBody?.affectedByGravity = false
        //mainChar.physicsBody?.restitution = 0
        
        mainChar.zPosition = 1
        addChild(mainChar)
    }
    
    func createGround() {
        
        for i in 0...3 {
            
            let ground = SKSpriteNode(imageNamed: "Source/SYY2mJz.png")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            ground.anchorPoint = CGPoint(x: 0, y: 0)
            ground.position = CGPoint(x: CGFloat(i)*ground.size.width, y: 0)
            
            ground.zPosition = -2
            self.addChild(ground)
        }
    }
    
    func moveGround() {
        
        self.enumerateChildNodes(withName: "Ground", using: ({
            
            (node,error) in
            node.position.x -= 2
            
            if (node.position.x < -(self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)!*3
                
            }
            
        }))
    }
    
    func AddBullet() {
        
        let bulletTexture = SKTexture(imageNamed: "Source/kisspng-bullet-ammunition-sprite-5b1fd18b49ff69.6301628015288119153031")
        let bullet = mySpriteNode(texture: bulletTexture)
        
        bullet.position = CGPoint(x: mainChar.frame.origin.x + mainChar.frame.width/2, y: mainChar.position.y)
        
        bullet.size = CGSize(width: bullet.size.width/10, height: bullet.size.height/10)
        bullet.health = 1
        
        addChild(bullet)
        
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: CGSize(width: bullet.size.width, height: bullet.size.height))
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        bullet.physicsBody?.affectedByGravity = false
        //bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        //let Interval: Double = interval(location: CGPoint(x: bullet.frame.origin.x,y: (view?.frame.height)!), present: bullet.position)
        
        let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x + 300, y: bullet.position.y ),duration: 0.5)
        
        //let bulletAnimation = SKAction.run {self.runBeamAnimation(Interval: Interval)}
        //run(loseAction)
        
        let actionMoveDone = SKAction.removeFromParent()
        let group = SKAction.sequence([actionMove,actionMoveDone])
        
        bullet.run(group)
        
    }
    
    func AddObstacle() {
        
        let random1 = Int(arc4random_uniform(UInt32((2))))
        var random = Double()
        
        if (random1 == 1) {random = 1.5}
        else {random = 3}
        
        //let random = Double(())/2 + 3/2);
        var ostacleTexture = SKTexture()
       
        if (random == 3) {
            ostacleTexture = SKTexture(imageNamed: "Source/Unknown") //st else
            ostacle = mySpriteNode(texture: ostacleTexture);
            ostacle.size = CGSize(width: ostacle.size.width/1.2, height: ostacle.size.height/1.2)
            ostacle.health = -1;
        }
        else {
            ostacleTexture = SKTexture(imageNamed: "Wolf_0") //st else
            ostacle = mySpriteNode(texture: ostacleTexture);
            ostacle.size = CGSize(width: ostacle.size.width * 1.5, height: ostacle.size.height * 1.5)
            ostacle.health = 1;
        }
        
        ostacle.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.size.height)!/3.6);
        
        ostacle.physicsBody = SKPhysicsBody(texture: ostacle.texture!, size: CGSize(width: ostacle.size.width, height: ostacle.size.height))
        ostacle.physicsBody?.isDynamic = true // 2
        ostacle.physicsBody?.affectedByGravity = false
        ostacle.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
        ostacle.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        ostacle.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        addChild(ostacle)
        
        let actionMove = SKAction.move(to: CGPoint(x: 0, y: (scene?.size.height)!/3.6),duration: TimeInterval(random))
            
        let actionMoveDone = SKAction.removeFromParent()
        let ostacleAnimation = SKAction.repeatForever(SKAction.animate(with: obstacleFram, timePerFrame: 0.2));
        
        if (random == 3) {
            let group = SKAction.sequence([actionMove,actionMoveDone]);
            ostacle.run(group);
        }
        else {
            let group = SKAction.group([SKAction.sequence([actionMove,actionMoveDone]),ostacleAnimation]);
            ostacle.run(group);
        }
    }
    
    func BlinkAnimation() -> SKAction {
        
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.25)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration:0.25)
        let blink = SKAction.sequence([fadeOut,fadeIn])
        let action = SKAction.repeat(blink, count: 4)
        return action;
    }
    
    func GameOver() {
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: self.score)
        self.view?.presentScene(gameOverScene, transition: reveal)
        
        
        
    }
        
    
    override func didMove(to view: SKView) {
        
        let bullet = SKSpriteNode(imageNamed: "Source/bullet");
        bullet.position = CGPoint(x: ((scene?.size.width)!) * 4/5, y: ((scene?.size.height)!) * 1/13);
        bullet.size = CGSize(width: bullet.size.width/2.7, height: bullet.size.height/2.7)
        
        Score.position = CGPoint(x: ((scene?.size.width)!) * 5/6 , y: ((scene?.size.height)!) * 7/8);
        Score.fontColor = UIColor.black
        Score.fontName = "Bold"
        Score.fontSize = 40
        addChild(Score)
        
        number.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        number.position.y = bullet.position.y - 10
        number.position.x = bullet.position.x + 70
        number.fontColor = UIColor.black
        number.fontName = "Bold"
        
        addChild(bullet);
        addChild(number);
        
        for i in 1...5 {
            let newsprite = SKSpriteNode(imageNamed: "Source/Unknown2")
            newsprite.position.y = ((scene?.size.height)!) * 7/8;
            newsprite.position.x = CGFloat(i) * ((scene?.size.width)!) / 12;
            newsprite.xScale /= 4; newsprite.yScale /= 4;
            health.append(newsprite)
            addChild(newsprite);
        }
        
        createGround();
        CreateChar();
        
        runningFrame = builAnimation(animationFile: "Runn")
        jumppingFram = builAnimation(animationFile: "Jump")
        shootingFram = builAnimation(animationFile: "Shoot")
        obstacleFram = builAnimation(animationFile: "Wolf")
        
        physicsWorld.contactDelegate = self
        physicsBody?.restitution = 0
        
        swipeUpRec.addTarget(self, action: #selector(jump));
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
         let ostacle = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.1),SKAction.run(AddObstacle)]))
        let action = SKAction.repeatForever(SKAction.animate(with: runningFrame, timePerFrame: 0.1, resize: false, restore: true))
        
        mainChar.run(SKAction.group([ostacle,action]));
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveGround();
        //if (ostacle.position.x < 0) {ostacle.removeFromParent();}
        print(bull)
        Score.text = "Score  " + String(score)
        
        if (bull != 0) {
            number.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            number.removeAllActions();
            number.fontSize = 40
            number.text = String(bull);
        }
        else if (!IsReset) {
            number.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            number.fontSize = 17
            let action1 = SKAction.run { self.number.text = String("IS LOADING") };
            let action2 = SKAction.repeatForever(BlinkAnimation())
            
            IsReset = true;
            
            let action3 = SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
                self.bull = 20; self.IsReset = false; } ])
            
            number.run(SKAction.group([action1,action2,action3]))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        self.isPaused = false
        if (bull > 0 && !IsTouch) {
            
            run(SKAction.playSoundFileNamed("Source/sounds/shotty.wav", waitForCompletion: false));
            
            let action = SKAction.animate(with: shootingFram, timePerFrame: 0.1);
            mainChar.run(action);
            
            AddBullet();
            bull -= 1;
        }
    }
    
    @objc func jump() {
        
        if (IsEnable) {return}
        
        IsEnable = true;
        
        let action1 = SKAction.run { self.IsEnable = true }
            //self.mainChar.xScale /= 1.1; self.mainChar.yScale /= 1.4 }
        
        let action2 = SKAction.moveTo(y: mainChar.position.y + 150, duration: 0.45)
        let action3 = SKAction.moveTo(y: mainChar.position.y, duration: 0.45)
        let action4 = SKAction.run { self.IsEnable = false }
        let action5 = SKAction.animate(with: jumppingFram, timePerFrame: 0.11, resize: false, restore: true)
            //self.mainChar.xScale *= 1.1; self.mainChar.yScale *= 1.4 }
        
        //mainChar.removeAction(forKey: "Jumpping")
        
        let action = SKAction.sequence([action1,action2,action3,action4]);
        let fullact = SKAction.group([action,action5]);
        //mainChar.run(SKAction.moveTo(y: mainChar.position.y + 100, duration: 2));
        
        mainChar.run(fullact)
        
        run(SKAction.playSoundFileNamed("Source/sounds/126416__cabeeno-rossley__jump", waitForCompletion: false))
    }
    
    func projectileDidCollideWithMonster(projectile: mySpriteNode, monster: mySpriteNode) {
        //print("Hit")

        run(SKAction.playSoundFileNamed("Source/sounds/boulder_impact_from_catapult_or_trebuchet.mp3", waitForCompletion: false))
        
        if (projectile == mainChar) {
            //print(IsCollide)
            if (!IsCollide) {
                IsCollide = true; //key line
                //print("ENter")
                mainChar.health = mainChar.health - 1
                let newSprite = health.popLast()
                newSprite?.removeFromParent();
                
                let action1 = SKAction.wait(forDuration: 2)
                //let action2 = SKAction.wait(forDuration: 30)
                let action3 = SKAction.run { self.IsCollide = false; }
                let action4 = SKAction.run {
                    self.mainChar.run(self.BlinkAnimation())
                }
                run(SKAction.group([SKAction.sequence([action1,action3]), action4]))
            }
        }
        else {
            projectile.removeFromParent();
            monster.health -= 1;
        }
        
        
        if (mainChar.health == 0) {GameOver(); }
        if (monster.health == 0) { monster.removeFromParent(); score = score + 1 }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //if (IsCollide) {return;}
        //print("DId Happend");
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? mySpriteNode,
                let projectile = secondBody.node as? mySpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
        
        //Score.text = String(score);
        
    }
}
