
import Foundation
import SpriteKit

/**
 Builds the tilemap's grid SKNode for convenient navigation in the gameworld
 */
class GridLayer: SKNode {
    /** A weak reference back to the tilemap for convenience */
    weak var tilemap: Tilemap!
    /** A 2D array of integer data representing the map - occupied cells*/
    var layerData: [[Int]]
    
    init(tilemap: Tilemap, data: [[Int]]) {
        self.tilemap = tilemap
        self.layerData = data
        super.init()
        self.name = "grid"
        buildLayer()
    }
    
    convenience init(tilemap: Tilemap){
        self.init(tilemap: tilemap, data: [[Int]]())
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tilemap = aDecoder.decodeObject(forKey: "Tilemap") as! Tilemap
        self.layerData = aDecoder.decodeObject(forKey: "LayerData") as! [[Int]]
        super.init(coder: aDecoder)
        buildLayer()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(tilemap, forKey: "Tilemap")
        aCoder.encode(layerData, forKey: "LayerData")
        super.encode(with: aCoder)
    }
    
    /** Generate the grid layer using shape nodes. */
    func buildLayer() {
        //  Grid
        for x in 0..<Int(tilemap.mapSizeInTiles.width) {
            for y in 0..<Int(tilemap.mapSizeInTiles.height) {
                let node = tilemap.tileShapeNode()
                node.strokeColor = UIColor(red: 0.1, green: 0.1, blue: 1, alpha: 1)
                node.position = tilemap.positionForPoint(point: CGPoint(x: x, y: y))
                addChild(node)
            }
        }
        //  Occupied cells
        for y in 0..<layerData.count {
            for x in 0..<layerData[y].count {
                if (layerData[y][x] == 1){
                    let node = tilemap.tileShapeNode()
                    node.fillColor = UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 0.5)
                    node.position = tilemap.positionForPoint(point: CGPoint(x: x, y: y))
                    node.zPosition = 256
                    addChild(node)
                }
            }
        }
    }
}
