import Foundation
import SpriteKit

/**
 The class responsible for dealing with Map
 */
class Tilemap {
    
    var mapSizeInTiles: CGSize
    
    let tileSizeInPixels: CGSize
    
    var tilemapSizeInPixels: CGSize {
        get {
            let width = mapSizeInTiles.width * tileSizeInPixels.width
            let height = mapSizeInTiles.height * tileSizeInPixels.height
            return CGSize(width: width, height: height)
        }
    }
    
    init(mapSizeInTiles: CGSize, tileSizeInPixels: CGSize) {
        self.mapSizeInTiles = mapSizeInTiles
        self.tileSizeInPixels = tileSizeInPixels
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mapSizeInTiles = aDecoder.decodeCGSize(forKey: "MapSize")
        self.tileSizeInPixels = aDecoder.decodeCGSize(forKey: "TileSize")
    }
    
    /**
     Returns the tile shape (square)
     */
    func tileShapeNode() -> SKShapeNode {
        return SKShapeNode(rectOf: tileSizeInPixels)
    }
    
    /**
     Convert from map point into pixel position of the centre of the
     tile at that point. Square maps render from the top left.
     
     - parameter point: The map point to convert to position
     - returns: CGPoint The pixel position of the centre of the tile at that point
     */
    func positionForPoint(point: CGPoint) -> CGPoint {
        let x = tileSizeInPixels.width / 2.0 + point.x * tileSizeInPixels.width
        let y = tilemapSizeInPixels.height - (tileSizeInPixels.height / 2.0 + point.y * tileSizeInPixels.height)
        return CGPoint(x: x, y: y)
    }
    
    /**
     Convert from a pixel position on the screen to a map tile coordinate
     - parameter position: The pixel position on the screen
     - returns: CGPoint The map coordinate of the tile at that position
     */
    func pointForPosition(position: CGPoint) -> CGPoint {
        let x = floor(position.x / tileSizeInPixels.width)
        let y = floor((tilemapSizeInPixels.height - position.y) / tileSizeInPixels.height)
        return CGPoint(x: x, y: y)
    }
    
    func adjustedPositionForPoint(point: CGPoint, adjust: CGPoint) -> CGPoint {
        let x = tileSizeInPixels.width / 2.0 + point.x * tileSizeInPixels.width
        let y = tilemapSizeInPixels.height - (point.y * tileSizeInPixels.height)
        return CGPoint(x: x, y: y)
    }
}
