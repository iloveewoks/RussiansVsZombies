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
    var levelManager: LevelManager!
    
    var gameCamera = SKCameraNode()
    
    /*
     =====================================================================================
     MARK: - Lifecycle
     =====================================================================================
     */
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        gameManager = GameManager.sharedInstance
        
        gameCamera = childNode(withName: "MainCamera") as! SKCameraNode
        camera = gameCamera
        
        levelManager = LevelManager(viewportISO: childNode(withName: "ISOMap") as! Viewport, gameCamera: gameCamera)
        
        gameManager.set(scene: self)
        
        gameManager.stateMachine.enter(ReadyState.self)
        
    }
    
    /*
     =====================================================================================
     MARK: - Scene Update
     =====================================================================================
     */
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (lastUpdateTime == 0) {
            lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - lastUpdateTime
        
        if (levelManager.viewportISO.isPaused){
            return
        }
        
        // Update
        levelManager.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
        
        if (gameManager.stateMachine.currentState is WinState){
            //WIN
        }
        
        if (gameManager.lives == 0){
            //LOSE
            gameManager.stateMachine.enter(LoseState.self)
        }
    }
    
    
    override func didFinishUpdate() {
        if (levelManager.viewportISO.isPaused){
            return
        }
        
        levelManager.didFinishUpdate()
    }
    
    /*
     =====================================================================================
     MARK: Touches Handler
     =====================================================================================
     */
    
    // Camera Movement
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        levelManager!.touchesMoved(touches, with: event)
    }
}
