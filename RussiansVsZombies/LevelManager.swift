import UIKit

import SpriteKit
import GameplayKit

class GameManager {
    
    var scene: GameScene?
    
    static let sharedInstance: GameManager = GameManager()
    
    init(){
        
    }
    
    func set(scene:GameScene){
        self.scene = scene
    }
}
