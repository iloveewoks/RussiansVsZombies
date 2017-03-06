import SpriteKit
import GameplayKit

class PausedState: State {
    override func didEnter(from previousState: GKState?) {
        scene.childNode(withName: "StartGame")?.isHidden = false
    }
}
