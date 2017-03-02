
import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    let fullHealth: Int
    var health: Int
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode
    let entityManager: EntitiesManager
    
    let soundAction = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)
    
    init(parentNode: SKNode, barWidth: CGFloat,
         barOffset: CGFloat, health: Int, entityManager: EntitiesManager) {
        
        self.fullHealth = health
        self.health = health
        self.entityManager = entityManager
        
        healthBarFullWidth = barWidth
        healthBar = SKShapeNode(rectOf:
            CGSize(width: healthBarFullWidth, height: 5), cornerRadius: 1)
        healthBar.fillColor = UIColor.green
        healthBar.strokeColor = UIColor.green
        healthBar.position = CGPoint(x:0, y:barOffset)
        parentNode.addChild(healthBar)
        
        healthBar.isHidden = true
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage(damage: Int) {
        health = max(health - damage, 0)
        healthBar.isHidden = false
        let healthScale = CGFloat(health)/CGFloat(fullHealth)
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0)
        let alignLeft = SKAction.moveTo(x: (healthScale-1)*healthBarFullWidth/2, duration: 0)
        
        healthBar.run(SKAction.group([scaleAction, alignLeft]))
        // kill the entity if it's dead
        if health == 0 {
            entityManager.removeEntity(entity: self.entity!)
        }
    }
    
}


