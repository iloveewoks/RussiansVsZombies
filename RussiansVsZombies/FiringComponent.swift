
import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
    
    let towerType: TowerType
    let parentNode: SKNode
    weak var currentTarget: EnemyEntity?
    var timeTillNextShot: TimeInterval = 0
    //  we need entities handler, because firing component creates projectiles
    var entitiesManager: EntitiesManager
    
    init(towerType: TowerType, parentNode: SKNode, entitiesManager: EntitiesManager) {
        self.towerType = towerType
        self.parentNode = parentNode
        self.entitiesManager = entitiesManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        timeTillNextShot -= seconds
        if timeTillNextShot > 0 { return }
        timeTillNextShot = towerType.fireRate
        
        chooseTarget()
        guard let target = currentTarget else { return }
        
        let projectile = ProjectileEntity(towerType: towerType, target: target, entitiesManager: entitiesManager)
        let projectileNode = projectile.spriteComponent.node
        projectileNode.position = parentNode.position
        entitiesManager.addEntity(entity: projectile)
        
    }
    
    //  The function selects the most suitable (closest) target for attack among other
    func chooseTarget() {
        //  Check if current target is suitable for attacking
        if currentTarget == nil || distanceBetween(nodeA: parentNode, nodeB: (currentTarget?.spriteComponent?.node)!) > towerType.range {
            currentTarget = nil
            var curDist = towerType.range
            let targets = entitiesManager.getEnemies()
            for target in targets {
                let distance = distanceBetween(nodeA: parentNode, nodeB: (target.spriteComponent?.node)!)
                if  distance < curDist{
                    curDist = distance
                    currentTarget = target
                }
            }
        }
    }
}


