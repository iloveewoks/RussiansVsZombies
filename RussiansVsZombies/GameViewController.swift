//
//  GameViewController.swift
//  RussiansVsZombies
//
//  Created by Dmitriy Kapitun on 15/02/17.
//  Copyright © 2017 Dmitriy Kapitun. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene(fileNamed:"MainMenuScene") {
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
