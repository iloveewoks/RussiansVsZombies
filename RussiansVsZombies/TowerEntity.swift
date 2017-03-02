import UIKit
import SpriteKit
import GameplayKit

class TowerEntity: GKEntity {
    
    let towerType: TowerType
    var spriteComponent: SpriteComponent!
    var shadowComponent: ShadowComponent!
    var animationComponent: AnimationComponent!
    var firingComponent: FiringComponent!
    
    init(towerType: TowerType, entitiesHandler: EntitiesManager) {
        // Store the TowerType
        self.towerType = towerType
        
        super.init()
        
        let defaultTexture = SKTexture(imageNamed:
            "\(towerType.rawValue)")
        let textureSize = CGSize(width: 98, height: 140)
        
        // Add the SpriteComponent
        spriteComponent = SpriteComponent(entity: self,
                                          texture: defaultTexture, size: textureSize)
        addComponent(spriteComponent)
        
        // Add the ShadowComponent
        let shadowSize = CGSize(width: 98, height: 44)
        shadowComponent = ShadowComponent(size: shadowSize,
                                          offset: CGPoint(x: 0.0,
                                                          y: -textureSize.height/2 + shadowSize.height/2))
        addComponent(shadowComponent)
        
        // Add the AnimationComponent
        animationComponent = AnimationComponent(node: spriteComponent.node,
                                                textureSize: textureSize, animations: loadAnimations())
        addComponent(animationComponent)
        
        firingComponent = FiringComponent(towerType: towerType,
                                          parentNode: spriteComponent.node, entitiesManager: entitiesHandler)
        addComponent(firingComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: towerType.rawValue)
        var animations = [AnimationState: Animation]()
        
        animations[.Idle] = AnimationComponent.animationFromAtlas(
            atlas: textureAtlas,
            withImageIdentifier: "Idle",
            forAnimationState: .Idle)
        animations[.Attacking] = AnimationComponent.animationFromAtlas(
            atlas: textureAtlas,
            withImageIdentifier: "Attacking",
            forAnimationState: .Attacking)
        
        return animations
    }
    
}

enum TowerType: String {
    case Wood = "WoodTower"
    case Rock = "RockTower"
    case Third = "ThirdTower" //WOW SO MUCH CREATIVITY
    
    static let allValues = [Wood, Rock, Third]
    
    var cost: Double {
        switch self {
        case .Wood: return 50
        case .Rock: return 70
        case .Third: return 120
        }
    }
    
    var fireRate: Double {
        switch self {
        case .Wood: return 1.0
        case .Rock: return 1.5
        case .Third: return 1.5
        }
    }
    
    var damage: Int {
        switch self {
        case .Wood: return 20
        case .Rock: return 50
        case .Third: return 70
        }
    }
    
    var range: CGFloat {
        switch self {
        case .Wood: return 400
        case .Rock: return 400
        case .Third: return 400
        }
    }
    
    var speedOfProjectile: CGFloat {
        switch self {
        case .Wood: return 400
        case .Rock: return 500
        case .Third: return 600
        }
    }
}
