import Foundation
import SpriteKit

struct Wave {
    let enemyCount: Int
    let enemyDelay: Double
    let enemyType: EnemyType
}

class WaveManager {
    
    var currentWave = 0
    var currentWaveEnemyCount = 0
    
    let waves: [Wave]
    
    let newWaveHandler: (_ waveNum: Int) -> Void
    let newEnemyHandler: (_ mobType: EnemyType) -> Void
    
    init(waves: [Wave],
         newWaveHandler: @escaping (_ waveNum: Int) -> Void,
         newEnemyHandler: @escaping (_ enemyType: EnemyType) -> Void) {
        self.waves = waves
        self.newWaveHandler = newWaveHandler
        self.newEnemyHandler = newEnemyHandler
        
    }
    
    func startNextWave() -> Bool {
        // 1
        if waves.count <= currentWave {
            GameManager.sharedInstance.stateMachine.enter(WinState.self)
            return true
        }
        
        // 2
        self.newWaveHandler(currentWave+1)
        
        // 3
        let wave = waves[currentWave]
        currentWaveEnemyCount = wave.enemyCount
        for m in 1...wave.enemyCount {
            delay(delay: wave.enemyDelay * Double(m), closure: { () -> () in
                self.newEnemyHandler(wave.enemyType)
            })
        }
        
        // 6
        currentWave += 1
        
        // 7
        return false
    }
    
    func removeEnemyFromWave() -> Bool {
        currentWaveEnemyCount -= 1
        if currentWaveEnemyCount <= 0 {
            GameManager.sharedInstance.stateMachine.enter(ReadyState.self)
        }
        return false
    }
    
    func startFirstWave() {
        print("Start first wave!")
        
        self.startNextWave()
    }
    
}


