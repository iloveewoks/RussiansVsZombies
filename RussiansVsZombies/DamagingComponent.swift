//
//  DamagingComponent.swift
//  TWDFS
//
//  Created by Ars Poyezzhayev on 13.11.16.
//  Copyright © 2016 AlexeyMukhin. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DamagingComponent: GKComponent {
    
    let damage: Int
    let destroySelf: Bool
    var lastDamageTime: TimeInterval
    weak var target: GKEntity?
    let aoe: Bool
    let entityManager: EntitiesManager
    
    init(damage: Int, destroySelf: Bool, aoe: Bool, entityManager: EntitiesManager, target: GKEntity) {
        self.damage = damage
        self.target = target
        self.destroySelf = destroySelf
        self.aoe = aoe
        self.lastDamageTime = 0
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeDamage(){
        target?.component(ofType: HealthComponent.self)?.takeDamage(damage: damage)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        // Get required components
        guard let enemyNode = target?.component(ofType: SpriteComponent.self)?.node else  {
            entityManager.removeEntity(entity: self.entity!)
            return
        }
        let node = self.entity!.component(ofType: SpriteComponent.self)!.node
        // Check for intersection
        if (node.calculateAccumulatedFrame().intersects(enemyNode.calculateAccumulatedFrame())) {
            // Cause damage
            makeDamage()
            
            // Destroy self
            if destroySelf {
                entityManager.removeEntity(entity: self.entity!)
            }
        }
    }
}
