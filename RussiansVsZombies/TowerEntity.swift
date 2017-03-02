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
