import Foundation
import GameKit

class EntitiesManager {
    
    var entities = Set<GKEntity>()
    
    //  Temporary collections
    var toRemove = Set<GKEntity>()
    var towers = [TowerEntity]()
    var enemies = [EnemyEntity]()
    
    //  Need for convenience. We could directly access the map node
    let viewport: Viewport
    var tilemap: Tilemap!
    
    var towerSelectorNodes = [TowerSelectorNode]()
    var placingTower = false
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(
            componentClass: AnimationComponent.self)
        let firingSystem = GKComponentSystem(componentClass: FiringComponent.self)
        let damagingSystem = GKComponentSystem(componentClass: DamagingComponent.self)
        let movingSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [animationSystem, firingSystem, damagingSystem, movingSystem]
    }()
    
    
    init(viewport: Viewport, tilemap: Tilemap) {
        self.viewport = viewport
        self.tilemap = tilemap
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            
            viewport.addNode(node: spriteNode, to: .Sprites)
        }
    }
    
    func removeEntity(entity: GKEntity){
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        if let spriteNode = entity.component(ofType: ShadowComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func addTower(towerType: TowerType, position: CGPoint) {
        let towerEntity = TowerEntity(towerType: towerType, entitiesHandler: self)
        towerEntity.spriteComponent.node.position = position
        addEntity(entity: towerEntity)
    }
    
    func addEnemy(enemyType: EnemyType,
                  path: [(Int, Int)],
                  pathHandler: (_ enemy: EnemyEntity, _ path: [(Int, Int)]) -> Void) {
        
        // TEMP - Will be removed later
        var updPath = path
        let startNode = updPath.removeFirst()
        let startPosition = tilemap.positionForPoint(point: CGPoint(x: (startNode.0), y: (startNode.1)))
        
        let enemy = EnemyEntity(enemyType: enemyType, entitiesManager: self)
        let enemyNode = enemy.spriteComponent.node
        enemyNode.position = startPosition
        pathHandler(enemy, updPath)
        
        
        addEntity(entity: enemy)
        
        enemy.animationComponent.requestedAnimationState = .Walk
    }
    
    func loadTowerSelectorNodes() {
        // 1
        let towerTypeCount = TowerType.allValues.count
        
        // 2
        let towerSelectorNodePath: String = Bundle.main
            .path(forResource: "TowerSelector", ofType: "sks")!
        let towerSelectorNodeScene = NSKeyedUnarchiver.unarchiveObject(withFile: towerSelectorNodePath) as! SKScene
        for t in 0..<towerTypeCount {
            // 3
            let towerSelectorNode = (towerSelectorNodeScene.childNode(
                withName: "MainNode"))!.copy() as! TowerSelectorNode
            // 4
            towerSelectorNode.setTower(towerType: TowerType.allValues[t],
                                       angle: ((2*π)/CGFloat(towerTypeCount))*CGFloat(t))
            // 5
            towerSelectorNodes.append(towerSelectorNode)
        }
    }
    
    func showTowerSelector(atPosition position: CGPoint) {
        
        if placingTower == true {return}
        placingTower = true
        
        for towerSelectorNode in towerSelectorNodes {
            // 3
            towerSelectorNode.position = position
            
            // TODO: make shadows
            
            self.viewport.addNode(node: towerSelectorNode,
                                  to: .Hud)
            // 5
            towerSelectorNode.show()
        }
    }
    
    func hideTowerSelector() {
        
        if placingTower == false { return }
        placingTower = false
        
        for towerSelectorNode in towerSelectorNodes {
            towerSelectorNode.hide {
                towerSelectorNode.removeFromParent()
            }
        }
    }
    
    // Update entities
    func update(deltaTime: TimeInterval){
        for componentSystem in componentSystems{
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for curRemove in toRemove {
            // Добавить голду за смерть
            if curRemove is EnemyEntity {
                if (curRemove as! EnemyEntity).healthComponent.health == 0 {
                    GameManager.sharedInstance.gold = GameManager.sharedInstance.gold + 100
                    GameManager.sharedInstance.scene!.levelManager.waveManager.removeEnemyFromWave()
                } else {
                    GameManager.sharedInstance.lives = GameManager.sharedInstance.lives - 1
                }
            }
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: curRemove)
            }
        }
        
        toRemove.removeAll()
    }
    
    func getEnemies() -> [EnemyEntity] {
        return enemies
    }
    
    func getTowers() -> [TowerEntity] {
        return towers
    }
    
    // Did finish update
    func didFinishUpdate(){
        enemies = entities.flatMap { entity in
            if let enemy = entity as? EnemyEntity {
                return enemy
            }
            return nil
        }
        
        towers = entities.flatMap { entity in
            if let tower = entity as? TowerEntity {
                return tower
            }
            return nil
        }
        
        for enemy in enemies {
            if enemy.moveComponent != nil {
                if !enemy.moveComponent.isMoving {
                    removeEntity(entity: enemy)
                }
            }
        }
    }
}
