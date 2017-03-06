import SpriteKit
import GameplayKit

class ProjectileEntity: GKEntity {
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    var damagingComponent: DamagingComponent!
    
    init(towerType: TowerType, target: GKEntity, entitiesManager: EntitiesManager) {
        super.init()
        
        let texture = SKTexture(imageNamed:
            "\(towerType.rawValue)Projectile")
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        moveComponent = MoveComponent(target: target, speed: towerType.speedOfProjectile)
        addComponent(moveComponent)
        
        damagingComponent = DamagingComponent(damage: towerType.damage, destroySelf: true, aoe: false, entityManager: entitiesManager, target: target)
        addComponent(damagingComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
