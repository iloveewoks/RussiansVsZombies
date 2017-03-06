//
//  GameScene.swift
//  RussiansVsZombies
//
//  Created by Dmitriy Kapitun on 15/02/17.
//  Copyright © 2017 Dmitriy Kapitun. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    /*
     =====================================================================================
     MARK: - Properties
     =====================================================================================
     */
    
    var lastUpdateTime: TimeInterval = 0
    
    var gameManager: GameManager!
    
    
    
    /*
     =====================================================================================
     MARK: - Lifecycle
     =====================================================================================
     */
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        gameManager = GameManager.sharedInstance
        
        gameManager.set(scene: self)
        
        gameManager.stateMachine.enter(ReadyState.self)
        
    }
    
    /*
     =====================================================================================
     MARK: - Scene Update
     =====================================================================================
     */
    override func update(_ currentTime: TimeInterval) {
        
        if (gameManager.stateMachine.currentState is WinState){
            //WIN
        }
        
        if (gameManager.lives == 0){
            //LOSE
            gameManager.stateMachine.enter(LoseState.self)
        }
        
    }
}
