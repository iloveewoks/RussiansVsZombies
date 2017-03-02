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

