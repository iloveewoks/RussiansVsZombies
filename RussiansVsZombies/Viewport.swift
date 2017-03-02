import Foundation
import SpriteKit

/**
 Class of the gameWorld viewport. Different viewports may have different coordinate systems and dimensionality.
 */
class Viewport: SKNode {
    
    var model: Tilemap?
    var layers: [LayerType: SKNode]?
    
    init(model: Tilemap) {
        self.model = model
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        model = aDecoder.decodeObject(forKey: "Tilemap") as? Tilemap
        layers = aDecoder.decodeObject(forKey:"Layers") as? [LayerType: SKNode]
        super.init(coder: aDecoder)
        initLayers()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(model, forKey: "Tilemap")
        aCoder.encode(layers, forKey: "Layers")
        super.encode(with: aCoder)
    }
    
    func initLayers(){
        layers = LayersManager().linkLayers(_to:self)
    }
    
    //  Load addNode method for the layer
    func addNode(node: SKNode, to layer: LayerType){
        layers?[layer]?.addChild(node)
    }
}
