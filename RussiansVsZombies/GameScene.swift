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
    
    // hud
    var hud = SKNode()
    var playButton = SKNode()
    var pauseButton = SKNode()
    var goldLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    var winLabel: SKLabelNode!
    
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
        
        hud = gameCamera.childNode(withName: "Hud") as! SKNode!
        playButton = hud.childNode(withName: "StartGame") as! SKNode!
        pauseButton = hud.childNode(withName: "PauseGame") as! SKNode!
        goldLabel = hud.childNode(withName: "GoldLabel") as! SKLabelNode!
        livesLabel = hud.childNode(withName: "LivesLabel") as! SKLabelNode!
        waveLabel = hud.childNode(withName: "WaveLabel") as! SKLabelNode!
        winLabel = hud.childNode(withName: "WinLabel") as! SKLabelNode!
        
        
        playButton.isHidden = false
        pauseButton.isHidden = true
        
        levelManager = LevelManager(viewportISO: childNode(withName: "ISOMap") as! Viewport, gameCamera: gameCamera)
        
        levelManager.entitiesManager.loadTowerSelectorNodes()
        
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
            winLabel.isHidden = false
        }
        
        if (gameManager.lives == 0){
            winLabel.isHidden = false
            winLabel.text = "YOU LOSE"
            gameManager.stateMachine.enter(LoseState.self)
        }
    }
    
    
    override func didFinishUpdate() {
        if (levelManager.viewportISO.isPaused){
            return
        }
        
        levelManager.didFinishUpdate()
        goldLabel.text = "Gold: \( gameManager.gold)"
        livesLabel.text = "Lives: \( gameManager.lives)"
        waveLabel.text = "Wave: \( levelManager.waveManager.currentWave)"
    }
    
    /*
     =====================================================================================
     MARK: Touches Handler
     =====================================================================================
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches) {
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if (touchedNode.name == "StartGame" &&
                gameManager.stateMachine.currentState is ReadyState ||
                gameManager.stateMachine.currentState is PausedState ){
                gameManager.stateMachine.enter(ActiveState.self)
                
            } else if (touchedNode.name == "PauseGame"){
                levelManager.viewportISO.isPaused = true
                gameManager.stateMachine.enter(ReadyState.self)
                
            } else {
                if (levelManager.viewportISO.isPaused){
                    return
                }
                levelManager.touchesBegan(touches, with: event)
            }
        }
    }

    
    // Camera Movement
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        levelManager!.touchesMoved(touches, with: event)
    }
}
