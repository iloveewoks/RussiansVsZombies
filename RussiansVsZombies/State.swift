import SpriteKit
import GameplayKit

class State: GKState {
    unowned let scene: GameScene
    init(scene: GameScene) {
        self.scene = scene
    }
}
