import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
    //    weak var entity: GKEntity!
}

class SpriteComponent: GKComponent {
    
    // A node that gives an entity a visual sprite
    let node: EntityNode
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = EntityNode(texture: texture,
                          color: SKColor.white, size: size)
        if #available(iOS 10.0, *) {
            node.entity = entity
        } else {
            // Fallback on earlier versions
        }
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

