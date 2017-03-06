import SpriteKit
import GameplayKit

class LoseState: State {
    override func didEnter(from previousState: GKState?) {
        let transition = SKTransition.reveal(with: .down, duration: 1.0)
        
        let nextScene = GameScene(fileNamed:"MainMenuScene")!
        nextScene.scaleMode = .aspectFill
        
        scene.removeFromParent()
        
        scene.view!.presentScene(nextScene, transition: transition)
    }
}
