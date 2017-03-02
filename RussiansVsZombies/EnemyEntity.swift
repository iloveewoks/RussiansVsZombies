import Foundation
import UIKit
import GameplayKit
import SpriteKit

enum EnemyType: String {
    case TRex = "T-Rex"
    case Triceratops = "Triceratops"
    case TRexBoss = "T-RexBoss"
    
    var health: Int {
        switch self {
        case .TRex: return 1000
        case .Triceratops: return 40
        case .TRexBoss: return 1000
        }
    }
    
    var speed: CGFloat {
        switch self {
        case .TRex: return 100
        case .Triceratops: return 150
        case .TRexBoss: return 50
        }
    }
}

class EnemyEntity: GKEntity {
    
    // 1
    let enemyType: EnemyType
    let entitiesManager: EntitiesManager
    var spriteComponent: SpriteComponent!
    var shadowComponent: ShadowComponent!
    var animationComponent: AnimationComponent!
    var healthComponent: HealthComponent!
    var moveComponent: MoveComponent!
    
    // 2
    init(enemyType: EnemyType, entitiesManager: EntitiesManager) {
        self.enemyType = enemyType
        self.entitiesManager = entitiesManager
        super.init()
        
        // 3
        let size: CGSize
        switch enemyType {
        case .TRex, .TRexBoss:
            size = CGSize(width: 100, height: 130)
        case .Triceratops:
            size = CGSize(width: 100, height: 130)
            
        }
        
        // 4
        let textureAtlas = SKTextureAtlas(named: enemyType.rawValue)
        let defaultTexture = textureAtlas.textureNamed("Walk__01.png")
        
        // 5
        spriteComponent = SpriteComponent(entity: self,
                                          texture: defaultTexture, size: size)
        addComponent(spriteComponent)
        
        let shadowSize = CGSize(width: size.width, height: size.height * 0.3)
        shadowComponent = ShadowComponent(size: shadowSize,
                                          offset: CGPoint(x: 0.0, y: -size.height/2 + shadowSize.height/2))
        addComponent(shadowComponent)
        
        animationComponent = AnimationComponent(node: spriteComponent.node, textureSize: size, animations: loadAnimations())
        addComponent(animationComponent)
        
        healthComponent = HealthComponent(parentNode: spriteComponent.node,
                                          barWidth: size.width,
                                          barOffset: size.height,
                                          health: enemyType.health, entityManager: entitiesManager)
        addComponent(healthComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: enemyType.rawValue)
        var animations = [AnimationState: Animation]()
        
        animations[.Walk] = AnimationComponent.animationFromAtlas(
            atlas: textureAtlas,
            withImageIdentifier: "Walk",
            forAnimationState: .Walk)
        animations[.Hit] = AnimationComponent.animationFromAtlas(
            atlas: textureAtlas,
            withImageIdentifier: "Hurt",
            forAnimationState: .Hit,
            repeatTexturesForever: false)
        animations[.Dead] = AnimationComponent.animationFromAtlas(
            atlas: textureAtlas,
            withImageIdentifier: "Dead",
            forAnimationState: .Dead,
            repeatTexturesForever: false)
        
        return animations
    }
}
