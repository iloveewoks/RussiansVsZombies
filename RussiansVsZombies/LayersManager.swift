//
// Created by Ars Poyezzhayev on 06.11.16.
// Copyright (c) 2016 Ars Poyezzhayev. All rights reserved.
//

import Foundation
import SpriteKit

class LayersManager {
    // ======================================== Methods =======================================
    
    // Links layers to
    func linkLayers(_to parent: SKNode, layers: [LayerType] = LayerType.defaultLayers) -> [LayerType: SKNode]{
        var layersDictionary = [LayerType: SKNode]()
        for layerType in layers{
            let layer = SKNode()
            
            layersDictionary[layerType] = layer
            layer.name = layerType.nodeName
            layer.zPosition = layerType.rawValue
            // Add new created layer
            parent.addChild(layer)
        }
        return layersDictionary
    }
}


// ======================================== Enums =======================================

// The names and zPositions of all the key layers in the GameScene
enum LayerType: CGFloat {
    
    // The difference in zPosition between all the enemies, towers and obstacles
    static let zDeltaForSprites: CGFloat = 10
    
    // The zPositions of all the GameScene layers
    case Background = 0 //for the background filling the area outside the map
    case Shadows = 2000
    case Sprites = 4000
    case Hud = 6000 //for HUD detached from the map
    case Overlay = 8000
    
    // The name the layers in the GameScene scene file
    var nodeName: String {
        switch self {
        case .Background: return "Background"
        case .Shadows: return "Shadows"
        case .Sprites: return "Sprites"
        case .Hud: return "Hud"
        case .Overlay: return "Overlay"
        }
    }
    
    // All scene layers
    static var sceneLayers = [Background, Sprites, Hud, Overlay]
    // All map layers
    static var defaultLayers = [Background, Shadows, Sprites, Hud, Overlay]
}

