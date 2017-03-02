import SpriteKit
import GameplayKit

/* LEVELS */
var levels = [[[Int]]]();

class LevelManager {
    let mapSizeInTiles = CGSize(width: 25, height: 25)
    let tileWidth: CGFloat = 128.0
    let tileHeight: CGFloat = 64.0
    
    var currentLevel = 1
    let levelsCount = 2
    
    var entitiesManager: EntitiesManager
    var waveManager: WaveManager!
    
    var towerSelectorPosition: CGPoint?
    
    var graph: GKGridGraph<GKGridGraphNode>!
    
    var highlight: SKShapeNode!
    
    var tilemap: Tilemap!
    var viewportISO: Viewport!
    var groundLayer: TilemapLayer?
    var grid: GridLayer?
    
    var availableBuildingSpace: [[Bool]]?
    
    var gameCamera = SKCameraNode()
    
    
    init(viewportISO: Viewport, gameCamera: SKCameraNode) {
        self.viewportISO = viewportISO
        self.gameCamera = gameCamera
        
        tilemap = ISOTilemap(mapSizeInTiles: mapSizeInTiles,
                             tileWidth: tileWidth,
                             tileHeight: tileHeight)
        
        entitiesManager = EntitiesManager(viewport: self.viewportISO, tilemap: tilemap)
        
        
        setLevel(level: currentLevel - 1)
        
        //WAVES
        let waves = [Wave(enemyCount: 5, enemyDelay: 3, enemyType: .TRex),
                     Wave(enemyCount: 8, enemyDelay: 2, enemyType: .Triceratops),
                     Wave(enemyCount: 10, enemyDelay: 2, enemyType: .TRex),
                     Wave(enemyCount: 25, enemyDelay: 1, enemyType: .Triceratops),
                     Wave(enemyCount: 1, enemyDelay: 1, enemyType: .TRexBoss)]
        
        waveManager = WaveManager(waves: waves,
                                  newWaveHandler: {
                                    (waveNum) -> Void in
                                    //waveLabel.text = "Wave \(waveNum)/\(waves.count)"
                                    //SKAction.playSoundFileNamed("NewWave.mp3", waitForCompletion: false)
        }, newEnemyHandler: {
            (enemyType) -> Void in
            self.entitiesManager.addEnemy(enemyType: enemyType,
                                          path: self.getEnemiesPath(startRow: 10, startColumn: 0),
                                          pathHandler: {
                                            (enemy, path) -> Void in
                                            self.setEnemyOnPath(enemy: enemy, path: path)
            })
        })
        
        
        
        //example of a walkable path
        for element in getEnemiesPath(startRow: 10, startColumn: 0) {
            print(element)
        }
        
        // Testing
        highlight = tilemap.tileShapeNode()
        highlight.position = tilemap.positionForPoint(point: CGPoint.zero)
        highlight.strokeColor = UIColor.red
        highlight.zPosition = 1000
        viewportISO.addNode(node: highlight, to: .Overlay)
    }
    
    public func getEnemiesPath(startRow row: Int, startColumn column: Int) -> [(Int, Int)] {
        
        var tempLevel = levels[currentLevel - 1]
        
        var pathArray = [(Int, Int)]()
        
        var previousRow = row
        var previousColumn = column
        
        while (true) {
            pathArray.append((previousColumn, previousRow))
            
            if !pathAlreadyContains(array: pathArray, pair: (previousRow, previousColumn + 1)) && tempLevel[previousRow][previousColumn + 1] == 12 {
                previousColumn += 1
            } else if !pathAlreadyContains(array: pathArray, pair: (previousRow, previousColumn - 1)) && tempLevel[previousRow][previousColumn - 1] == 12 {
                previousColumn -= 1
            } else if !pathAlreadyContains(array: pathArray, pair: (previousRow + 1, previousColumn)) && tempLevel[previousRow + 1][previousColumn] == 12 {
                previousRow += 1
            } else if !pathAlreadyContains(array: pathArray, pair: (previousRow - 1, previousColumn)) && tempLevel[previousRow - 1][previousColumn] == 12 {
                previousRow -= 1
            } else {
                break
            }
        }
        
        return pathArray
    }
    
    func pathAlreadyContains(array: [(Int, Int)], pair: (Int, Int)) -> Bool {
        for (first, second) in array {
            if second == pair.0 && first == pair.1 {
                return true
            }
        }
        return false
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let tilemapPosition = tilemap.pointForPosition(position: touch.location(in: (viewportISO.layers?[.Sprites]!)!))
        highlight.position = tilemap.positionForPoint(point: tilemapPosition)
        
        if entitiesManager.placingTower {
            
            towerSelectorPosition?.y -= tileHeight/4
            
            let touchLocation = touch.location(in: viewportISO.layers![.Hud]!)
            let touchedNode = viewportISO.layers![.Hud]!.atPoint(touchLocation)
            
            let touchedNodeName = touchedNode.name!
            
            if touchedNodeName == "WoodTower" {
                if (Int(GameManager.sharedInstance.gold) - Int(TowerType.Wood.cost) > 0) {
                    GameManager.sharedInstance.gold = Int(GameManager.sharedInstance.gold) - Int(TowerType.Wood.cost)
                    entitiesManager.addTower(towerType: .Wood, position: towerSelectorPosition!)
                    let towerSelectorTileMapPosition = tilemap.pointForPosition(position: towerSelectorPosition!)
                    availableBuildingSpace![Int(towerSelectorTileMapPosition.x)][Int(towerSelectorTileMapPosition.y)] = false
                }
            }
            else if touchedNodeName == "RockTower" {
                if (Int(GameManager.sharedInstance.gold) - Int(TowerType.Rock.cost) > 0) {
                    GameManager.sharedInstance.gold = Int(GameManager.sharedInstance.gold) - Int(TowerType.Rock.cost)
                    entitiesManager.addTower(towerType: .Rock, position: towerSelectorPosition!)
                    let towerSelectorTileMapPosition = tilemap.pointForPosition(position: towerSelectorPosition!)
                    availableBuildingSpace![Int(towerSelectorTileMapPosition.x)][Int(towerSelectorTileMapPosition.y)] = false
                }
            }
            else if touchedNodeName == "ThirdTower" {
                if (Int(GameManager.sharedInstance.gold) - Int(TowerType.Third.cost) > 0) {
                    GameManager.sharedInstance.gold = Int(GameManager.sharedInstance.gold) - Int(TowerType.Third.cost)
                    entitiesManager.addTower(towerType: .Third, position: towerSelectorPosition!)
                    let towerSelectorTileMapPosition = tilemap.pointForPosition(position: towerSelectorPosition!)
                    availableBuildingSpace![Int(towerSelectorTileMapPosition.x)][Int(towerSelectorTileMapPosition.y)] = false
                }
            }
            
            entitiesManager.hideTowerSelector()
        } else {
            print("\(Int(tilemapPosition.x)) ========== \(Int(tilemapPosition.y))")
            if (Int(tilemapPosition.x) > 0 && Int(tilemapPosition.y) > 0) &&
                (Int(tilemapPosition.x) < 25 && Int(tilemapPosition.y) < 25) {
                if availableBuildingSpace![Int(tilemapPosition.x)][Int(tilemapPosition.y)] {
                    towerSelectorPosition = tilemap.positionForPoint(point: tilemapPosition)
                    
                    entitiesManager.showTowerSelector(atPosition: towerSelectorPosition!)
                }
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: viewportISO)
            let previousLocation = touch.previousLocation(in: viewportISO)
            
            let deltaX = location.x - previousLocation.x
            let deltaY = location.y - previousLocation.y
            gameCamera.position.x -= deltaX
            gameCamera.position.y -= deltaY
        }
    }
    
    func update(deltaTime: TimeInterval) {
        entitiesManager.update(deltaTime: deltaTime)
    }
    
    func didFinishUpdate(){
        entitiesManager.didFinishUpdate()
    }
    
    private func setLevel(level: Int) {
        loadLevel(filename: "level1.lvl")
        
        let tileset = TileSet(tilemap: tilemap,
                              filename: "TileSet")
        
        if groundLayer != nil {
            groundLayer!.removeFromParent()
        }
        
        groundLayer = TilemapLayer(tilemap: tilemap,
                                   data: levels[level],
                                   tileset: tileset)
        
        viewportISO.addNode(node: groundLayer!,
                            to: .Background)
        
        //Initialise and update available building space (only grass nodes)
        availableBuildingSpace = Array.init(repeating: Array.init(repeating: false, count: levels[level][0].count), count: levels[level].count)
        
        for y in 0..<availableBuildingSpace!.count {
            for x in 0..<availableBuildingSpace![y].count { //dunno why it's reversed but it is
                if (tileset[levels[level][y][x]]?.attributes.values.contains(where: { $0.contains("grass") }))! {
                    availableBuildingSpace![x][y] = true
                } else { availableBuildingSpace![x][y] = false }
            }
        }
        
        
        //if no grid is on the screen
        if (viewportISO.childNode(withName: "Grid") == nil) {
            grid = GridLayer(tilemap: tilemap)
            //initialize grid layer
            viewportISO.addNode(node: grid!,
                                to: .Background)
        }
        
    }
    
    public func setNextLevel() {
        if (currentLevel < levelsCount) {
            setLevel(level: currentLevel)
            currentLevel += 1
        } else {
            //TODO: levels ended!
        }
    }
    
    func setEnemyOnPath(enemy: EnemyEntity, path: [(Int, Int)]) {
        let enemyNode = enemy.spriteComponent.node
        
        enemyNode.removeAction(forKey: "move")
        
        var pathPoints = Array<CGPoint>()
        
        for (x, y) in path {
            let nodePosition = tilemap.positionForPoint(point: CGPoint(x: x, y: y))
            pathPoints.append(nodePosition)
        }
        
        let moveComponent = MoveComponent(path: pathPoints, speed: enemy.enemyType.speed)
        enemy.moveComponent = moveComponent
        enemy.addComponent(moveComponent)
        
    }
    
    func loadLevel(filename: String){
        let filePath = Bundle.main.path(forResource: filename, ofType: nil)!
        let level = NSArray(contentsOfFile: filePath) as! [[Int]]
        // Iterate through the dictionary to create a native Swift tileset
        levels.append(level);
    }
    
}
