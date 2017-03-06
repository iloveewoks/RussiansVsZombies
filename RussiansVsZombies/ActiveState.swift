import SpriteKit
import GameplayKit

class ActiveState: State {
    override func didEnter(from previousState: GKState?) {
        scene.playButton.isHidden = true
        scene.pauseButton.isHidden = false
        scene.levelManager.viewportISO.isPaused = false
        if scene.levelManager.waveManager.currentWave == 0 ||
            scene.levelManager.entitiesManager.enemies.count == 0{
            scene.levelManager.waveManager.startNextWave()
        }
    }
}
