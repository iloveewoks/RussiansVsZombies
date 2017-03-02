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
}
