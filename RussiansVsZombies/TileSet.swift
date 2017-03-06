import Foundation
import SpriteKit

/**
 Tileset (images) class. It assigns tiles' sprites to tile's IDs.
 */
class TileSet: NSObject, NSCoding {
    
    /** A weak reference to the tilemap for convenience */
    weak var tilemap: Tilemap!
    /** A dictionary containing the tiles in the set */
    let tiles: [Int: Tile]
    
    required init?(coder aDecoder: NSCoder) {
        self.tilemap = aDecoder.decodeObject(forKey: "Tilemap") as! Tilemap
        self.tiles = aDecoder.decodeObject(forKey: "Tiles") as! [Int: Tile]
    }
    
    /**
     Load a tileset from a pList file of a given name.
     
     - parameter tilemap: The tilemap the tileset is associated with
     - parameter filename: The filename of the plist file containing the tileset information.
     */
    init(tilemap: Tilemap, filename: String) {
        self.tilemap = tilemap
        var dict = [Int: Tile]()
        let filePath = Bundle.main.path(forResource: filename, ofType: "plist")!
        let set = NSDictionary(contentsOfFile: filePath)!
        // Iterate through the dictionary to create a native Swift tileset
        for (key, tile) in set {
            let intKey = Int(key as! String)!
            var tileAttributes = [String:String]()
            let td = tile as! NSDictionary
            for (tileKey,value) in td {
                let tk = tileKey as! String
                let tv = value as! String
                tileAttributes[tk] = tv
            }
            dict[intKey] = Tile(tilemap: tilemap, id: intKey, attributes: tileAttributes)
        }
        self.tiles = dict
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tilemap, forKey: "Tilemap")
        aCoder.encode(tiles, forKey: "Tiles")
    }
    
    /**
     Simplifies access to tile's ID
     */
    subscript(tileID: Int) -> Tile? {
        get {
            return tiles[tileID]
        }
    }
}
