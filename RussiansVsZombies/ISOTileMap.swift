import Foundation
import SpriteKit

class ISOTilemap: Tilemap {
    
    //=============Fields==============//
    
    private var tileWidth: CGFloat
    private var tileHeight: CGFloat
    
    override var tilemapSizeInPixels: CGSize {
        get {
            let width = tileWidth * (mapSizeInTiles.height + mapSizeInTiles.width) / 2.0
            let height = tileHeight * (mapSizeInTiles.height + mapSizeInTiles.width) / 2.0
            return CGSize(width: width, height: height)
        }
    }
    
    
    //===============Initializers=================
    
    init(mapSizeInTiles: CGSize, tileWidth: CGFloat, tileHeight: CGFloat) {
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        super.init(mapSizeInTiles: mapSizeInTiles, tileSizeInPixels: CGSize(width: tileWidth, height: tileHeight))
    }
    
    convenience init(mapSizeInTiles: CGSize, tileWidth: CGFloat) {
        self.init(mapSizeInTiles: mapSizeInTiles, tileWidth: tileWidth, tileHeight: tileWidth/2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tileWidth = CGFloat(aDecoder.decodeFloat(forKey: "tileWidth"))
        self.tileHeight = CGFloat(aDecoder.decodeFloat(forKey: "tileHeight"))
        super.init(coder: aDecoder)
    }
    
    
    //===============Methods=======================
    
    /**
     Returns the tile shape (diamond)
     */
    override func tileShapeNode() -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.0, y: -tileHeight/2.0))
        path.addLine(to: CGPoint(x: tileWidth / 2.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: tileHeight/2.0))
        path.addLine(to: CGPoint(x: -tileWidth/2.0, y: 0.0))
        path.closeSubpath()
        return SKShapeNode(path: path, centered: true)
    }
    
    /**
     Convert from map point into pixel position of the centre of the
     tile at that point. Square maps render from the top left.
     
     - parameter point: The map point to convert to position (row and column of the grid)
     - returns: CGPoint The pixel position of the centre of the tile at that point
     */
    override func positionForPoint(point: CGPoint) -> CGPoint {
        let x = (point.x - point.y) * tileWidth / 2.0
        let y = tilemapSizeInPixels.height - (point.x + point.y) * tileHeight / 2.0
        return CGPoint(x: x, y: y)
    }
    
    /**
     Convert from a pixel position on the screen to a map tile coordinate
     - parameter position: The pixel position on the screen
     - returns: CGPoint The map coordinate of the tile at that position
     */
    override func pointForPosition(position: CGPoint) -> CGPoint {
        let xs = position.x
        let ys = tilemapSizeInPixels.height - position.y
        let tileWidthHalf = tileWidth/2.0
        let tileHeightHalf = tileHeight/2.0
        let x = floor(((xs + tileWidthHalf) / tileWidthHalf + ys / tileHeightHalf) / 2.0)
        let y = floor(((ys + tileHeightHalf) / tileHeightHalf - xs / tileWidthHalf) / 2.0)
        return CGPoint(x: x, y: y)
    }
    
    override func adjustedPositionForPoint(point: CGPoint, adjust: CGPoint) -> CGPoint {
        let x = (point.x - point.y) * tileWidth / 2.0 + adjust.x
        let y = tilemapSizeInPixels.height - (point.x + point.y) * tileHeight / 2.0 - adjust.y
        return CGPoint(x: x, y: y)
        
    }
    
}
