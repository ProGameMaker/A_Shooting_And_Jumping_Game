//
//  GameOverScence.swift
//  ShootingGame
//
//  Created by Nguyễn Trí on 8/29/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        var savedScore: Int = 0
        if (UserDefaults.standard.object(forKey: "HighestScore") == nil) {
            savedScore = score
            print("No")
        }
        else {
            savedScore = UserDefaults.standard.object(forKey: "HighestScore") as! Int
            
            if (score > savedScore) { savedScore = score}
            print("Yes")
        }
        
        UserDefaults.standard.set(savedScore, forKey:"HighestScore")
        UserDefaults.standard.synchronize()
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = " Game Over\n\n Score: \(score) \n Best score: \(savedScore) "
        
        // 3

        let label = SKLabelNode(fontNamed: "Copperplate")
        label.numberOfLines = 4
        label.text = message
        label.horizontalAlignmentMode = .center
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                // 5
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
