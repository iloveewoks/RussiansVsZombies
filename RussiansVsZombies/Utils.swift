import CoreGraphics
import simd
import SpriteKit

// MARK: Points and vectors
extension CGPoint {
    init(_ point: float2) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}
extension float2 {
    init(_ point: CGPoint) {
        self.init(x: Float(point.x), y: Float(point.y))
    }
    
    func distanceTo(point: float2) -> Float {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return sqrt((xDist*xDist) + (yDist*yDist))
    }
}


// Rotate node to face another node
func rotateToFaceNode(targetNode: SKNode, sourceNode: SKNode) -> CGFloat {
    return (atan2(targetNode.position.y - sourceNode.position.y, targetNode.position.x - sourceNode.position.x) - CGFloat(M_PI/2))
}

func rotateToFacePosition(targetPosition: CGPoint, sourceNode: SKNode) -> CGFloat {
    return (atan2(targetPosition.y - sourceNode.position.y, targetPosition.x - sourceNode.position.x) - CGFloat(M_PI/2))
}


func delay(delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}


// Distance between nodes
func distanceBetween(nodeA: SKNode, nodeB: SKNode) -> CGFloat {
    return CGFloat(hypotf(Float(nodeB.position.x - nodeA.position.x), Float(nodeB.position.y - nodeA.position.y)));
}

// Degree and radian extensions
let π = CGFloat(M_PI)
public extension Int {
    public func degreesToRadians() -> CGFloat {
        return CGFloat(self).degreesToRadians()
    }
}
public extension CGFloat {
    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }
}

func distanceBetweenPoints(pointA: CGPoint, pointB: CGPoint) -> CGFloat{
    return CGFloat(hypotf(Float(pointB.x-pointA.x), Float(pointB.y - pointA.y)))
}
