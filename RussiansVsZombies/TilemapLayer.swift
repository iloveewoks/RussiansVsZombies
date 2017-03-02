
import Foundation
import SpriteKit

/**
 Basic layer of the tiled map. It is covered with tiles of tileset based on the structure of level.
 */
class TilemapLayer: SKNode {
    
    /** A weak reference back to the tilemap for convenience */
    weak var tilemap: Tilemap!
    /** A 2D array of integer data representing the map */
    let layerData: [[Int]]
    /** A set of image textures for building the layer */
    let tileset: TileSet
    
    /**
     Data is a representation of the level in array of Ints
     */
    init(tilemap: Tilemap, data: [[Int]], tileset: TileSet) {
        self.tilemap = tilemap
        self.layerData = data
        self.tileset = tileset
        super.init()
        buildLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tilemap = aDecoder.decodeObject(forKey: "Tilemap") as? Tilemap
        self.layerData = aDecoder.decodeObject(forKey: "LayerData") as! [[Int]]
        self.tileset = TileSet(tilemap: tilemap, filename: "TileSet")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(layerData, forKey: "LayerData")
        aCoder.encode(tilemap, forKey: "Tilemap")
        super.encode(with: aCoder)
    }
    
    /** Construct the layer given the layer data and image set */
    func buildLayer() {
        for y in 0..<layerData.count {
            for x in 0..<layerData[y].count {
                if let node = tileset[layerData[y][x]]?.spriteNode() {
                    node.position = tilemap.positionForPoint(point: CGPoint(x: x, y: y))
                    node.zPosition = tilemap.tilemapSizeInPixels.height - node.position.y
                    addChild(node)
                }
            }
        }
    }
}
