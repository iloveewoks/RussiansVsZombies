import UIKit

import SpriteKit
import GameplayKit

class GameManager {
    
    var scene: GameScene?
    
    var lives = 5
    var gold = 800
    var enemiesKilled = 0
    var waveHasStarted = false
    
    static let sharedInstance: GameManager = GameManager()
    
    init(){
        
    }
    
    func set(scene:GameScene){
        self.scene = scene
    }
    
    // A GameScene state machine
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        ReadyState(scene: self.scene!),
        ActiveState(scene: self.scene!),
        WinState(scene: self.scene!),
        LoseState(scene: self.scene!)
        ])
}
