
import Foundation
import GameplayKit
import SpriteKit

class ShadowComponent: GKComponent {
    
    let node: SKShapeNode
    
    init(size: CGSize, offset: CGPoint) {
        node = SKShapeNode(ellipseOf: size)
        node.fillColor = SKColor.black
        node.strokeColor = SKColor.black
        node.alpha = 0.2
        node.position = offset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
