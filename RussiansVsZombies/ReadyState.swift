import SpriteKit
import GameplayKit

class ReadyState: State {
    override func didEnter(from previousState: GKState?) {
        scene.playButton.isHidden = false
        scene.pauseButton.isHidden = true
    }
}
