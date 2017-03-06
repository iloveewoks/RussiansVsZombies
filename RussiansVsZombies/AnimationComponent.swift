import SpriteKit
import GameplayKit

enum AnimationState: String {
    case Idle = "Idle"
    case Walk = "Walk"
    case Hit = "Hit"
    case Dead = "Dead"
    case Attacking = "Attacking"
}

struct Animation {
    let animationState: AnimationState
    let textures: [SKTexture]
    //  If animation is repeatable
    let repeatTexturesForever: Bool
}

class AnimationComponent: GKComponent {
    
    let node: SKSpriteNode
    
    var animations: [AnimationState: Animation]
    
    private(set) var currentAnimation: Animation?
    
    var requestedAnimationState: AnimationState?
    
    init(node: SKSpriteNode, textureSize: CGSize,
         animations: [AnimationState: Animation]) {
        
        self.node = node
        self.animations = animations
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        
        if let animationState = requestedAnimationState {
            runAnimationForAnimationState(animationState: animationState)
            requestedAnimationState = nil
        }
    }
    
    class func animationFromAtlas(atlas: SKTextureAtlas,
                                  withImageIdentifier identifier: String,
                                  forAnimationState animationState: AnimationState,
                                  repeatTexturesForever: Bool = true) -> Animation {
        
        let textures = atlas.textureNames.filter {
            $0.hasPrefix("\(identifier)_")
            }.sorted {
                $0 < $1
            }.map {
                atlas.textureNamed($0)
        }
        
        return Animation(
            animationState: animationState,
            textures: textures,
            repeatTexturesForever: repeatTexturesForever
        )
    }
    
    private func runAnimationForAnimationState(
        animationState: AnimationState) {
        
        let actionKey = "Animation"
        
        let timePerFrame = TimeInterval(1.0 / 6.0)
        
        if currentAnimation != nil &&
            currentAnimation!.animationState == animationState { return }
        
        guard let animation = animations[animationState] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }
        
        node.removeAction(forKey: actionKey)
        
        let texturesAction: SKAction
        if animation.repeatTexturesForever {
            texturesAction = SKAction.repeatForever(
                SKAction.animate(
                    with: animation.textures, timePerFrame: timePerFrame))
        }
        else {
            texturesAction = SKAction.animate(
                with: animation.textures, timePerFrame: timePerFrame)
        }
        
        node.run(texturesAction, withKey: actionKey)
        
        currentAnimation = animation
    }
}


