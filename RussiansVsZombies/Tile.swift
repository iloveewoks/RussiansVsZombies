import Foundation
import SpriteKit


/**
 Tile class
 */
class Tile: NSObject, NSCoding {
    
    /** The tile id used in map data */
    let id: Int
    /** A dictionary of attributes relating to the tile */
    let attributes: [String: String]
    /** A weak reference to the containing tileset */
    weak var tilemap: Tilemap!
    
    init(tilemap: Tilemap, id: Int, attributes: [String: String]) {
        self.tilemap = tilemap
        self.id = id
        self.attributes = attributes
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tilemap = aDecoder.decodeObject(forKey: "Tilemap") as! Tilemap
        self.id = aDecoder.decodeInteger(forKey: "ID")
        self.attributes = aDecoder.decodeObject(forKey: "Attributes") as! [String: String]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tilemap, forKey: "Tilemap")
        aCoder.encode(self.id, forKey: "ID")
        aCoder.encode(attributes, forKey: "Attributes")
    }
    
    /**
     Returns the Sprite of the Tile. It is loaded on fly.
     */
    func spriteNode() -> SKSpriteNode {
        let imageName = attributes["imageName"]!
        let node = SKSpriteNode(imageNamed: imageName)
        let ratio = tilemap.tileSizeInPixels.height / node.size.height
        //  Equalizes the tiles' heights
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5 * ratio)
        //  Avoids the aliasing effect in case of non-default resolution
        node.texture!.filteringMode = .nearest
        node.name = "Cell"
        return node
    }
}
