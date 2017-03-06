import Foundation
import SpriteKit
import GameplayKit

class MoveComponent : GKComponent {
    var isMoving: Bool
    weak var target: SKSpriteNode?
    var targetPos: CGPoint
    let speed: CGFloat
    var path: [CGPoint]?
    var pathInd: Int?
    
    init(target: GKEntity, speed: CGFloat) {
        self.target = target.component(ofType: SpriteComponent.self)?.node
        self.speed = speed
        isMoving = true
        targetPos = CGPoint.zero
        super.init()
        
    }
    
    init(path: [CGPoint], speed: CGFloat) {
        self.speed = speed
        self.path = path
        pathInd = 0
        isMoving = true
        targetPos = path[pathInd!]
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if (isMoving){
            let node = self.entity?.component(ofType: SpriteComponent.self)?.node
            
            if path != nil {
                targetPos = path![pathInd!]
            } else if target != nil{
                targetPos = (target?.position)!
            }
            
            let distance = distanceBetweenPoints(pointA: (node?.position)!, pointB: targetPos)
            if distance < (node?.frame.width)!/2 {
                if path != nil && pathInd! + 1 < (path?.count)! {
                    pathInd! += 1
                    targetPos = path![pathInd!]
                } else {
                    isMoving = false
                    return
                }
            }
            
            
            let angle = rotateToFacePosition(targetPosition: targetPos, sourceNode: node!)
            let time = TimeInterval(distance/speed)
            let move = SKAction.move(to: targetPos, duration: time)
            
            let actions: SKAction
            
            if path != nil {
                actions = move
            } else { //Don't rotate enemies for now, fix later
                let rotate = SKAction.rotate(toAngle: angle, duration: 0)
                actions = SKAction.group([move,rotate])
            }
            
            self.entity?.component(ofType: SpriteComponent.self)?.node.run(actions)
        }
    }
    
    func setOnPath(_ path: [CGPoint]) {
        isMoving = true
        self.path = path
        pathInd = 0
    }
    
    func moveTo(position: CGPoint){
        targetPos = position
        isMoving = true
    }
    
    func moveTo(target: GKEntity){
        self.target = target.component(ofType: SpriteComponent.self)?.node
        isMoving = true
    }
    
    
}
