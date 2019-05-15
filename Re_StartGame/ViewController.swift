//
//  ViewController.swift
//  ShootingGame
//
//  Created by Nguyễn Trí on 8/25/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //view.addSubview(imageView)
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
