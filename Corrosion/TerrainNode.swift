//
//  TerrainNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-03.
//

import SpriteKit

class TerrainNode: SKNode {
    private let N_COLUMNS = 10
    private let TILE_SIZE: Int

    private var tiles: [[TileNode]]
    
    var onTileBrokenCallback: (()->Void)?
    
    init(scene: SKScene) {
        tiles = []
        TILE_SIZE = Int(scene.frame.width / CGFloat(N_COLUMNS))
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onLiquidTileCollision), name: .onLiquidTileCollision, object: nil)
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createTerrain() {
        guard let scene = scene else { fatalError("Could not create terrain, scene is nil") }
        let bottom = Int(scene.frame.minY)
        let midY = Int(scene.frame.midY)
        for tileMidY in stride(from: bottom, to: midY, by: TILE_SIZE) {
            tiles.append(createTerrainRow(at: tileMidY))
        }
        DepthController.instance.setDepth(depth: tiles.count)
    }
    
    private func createTerrainRow(at tileMidY: Int) -> [TileNode] {
        guard let scene = scene else { fatalError("Could not create terrain row, scene is nil") }
        var terrainRow: [TileNode] = []
        let left = Int(scene.frame.minX)
        let right = Int(scene.frame.maxX)
        for tileMidX in stride(from: left, to: right, by: TILE_SIZE) {
            let tilePosition = CGPoint(x: tileMidX + TILE_SIZE / 2, y: tileMidY - TILE_SIZE / 2)
            let tile = createTerrainTile(at: tilePosition)
            scene.addChild(tile)
            terrainRow.append(tile)
        }
        return terrainRow
    }
    
    private func createTerrainTile(at position: CGPoint) -> TileNode {
        let nodeSize = CGSize(width: TILE_SIZE, height: TILE_SIZE)
        let tile = TileNode(size: nodeSize, maxIntegrity: 100, tileType: .dirt)
        tile.position = position
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTileBroken), name: .onTileBroken, object: nil)
        
        return tile
    }
    
    private func getTile(at position: CGPoint) -> TileNode {
//        let index = Int(CGFloat(N_COLUMNS) * position.y + position.x)  // For 1D Arrays
        let row = Int(position.y)
        let column = Int(position.x)
        return tiles[row][column]
    }
    
    func updateTerrain() {
        for row in tiles {
            for tile in row {
                tile.update()
            }
        }
    }
    
    @objc func onTileBroken(_ notification: NSNotification) {
        guard let tile = notification.object as? TileNode else { fatalError("onTileBroken triggered by object other than TileNode") }
        removeFromTerrain(tile: tile)
        updateTerrainAfterCollision()
        onTileBrokenCallback?()
    }
    
    @objc private func onLiquidTileCollision(_ notification: Notification) {
        if let collisionData = notification.object as? LiquidTileCollision {
            handleTileCollision(liquid: collisionData.liquid, tile: collisionData.tile)
        }
    }
    
    private func handleTileCollision(liquid: SKNode, tile: SKNode) {
        guard let tile = tile as? TileNode else { return }
        liquid.removeFromParent()
        tile.damage(by: 1)
    }
    
    private func removeFromTerrain(tile: TileNode) {
        tile.removeFromParent()
        
        for row in 0..<tiles.count {
            for column in 0..<tiles[row].count {
                if tiles[row][column].position == tile.position {
                    tiles[row].remove(at: column)
                    return
                }
            }
        }
    }
    
    private func removeFromTerrain(row: [TileNode]) {
        for tile in row {
            removeFromTerrain(tile: tile)
        }
        
        if let index = tiles.firstIndex(of: row) {
            tiles.remove(at: index)
        }
    }
    
    private func shouldMoveTerrain() -> Bool {
        for i in 0..<4 {
            if tiles[i].count < N_COLUMNS { return true }
        }
        return false
    }
    
    private func moveRowUpwards(_ row: [TileNode]) -> Bool {
        guard let scene = scene else { fatalError("Could not move the row upwards, scene is nil") }
        let top = scene.frame.maxY
        for tile in row {
            let delta = CGVector(dx: 0, dy: TILE_SIZE)
            if (tile.position.y + delta.dy) > top {
                return false
            }
            tile.run(SKAction.move(by: delta, duration: 0.1))
        }
        return true
    }
    
    private func moveTerrainUpwards() {
        var toRemove: [[TileNode]] = []
        for row in tiles {
            let completed = moveRowUpwards(row)
            if !completed {
                toRemove.append(row)
            }
        }
        for row in toRemove {
            removeFromTerrain(row: row)
        }
    }
    
    private func updateTerrainAfterCollision() {
        if !shouldMoveTerrain() { return }
        let numberOfRows = 3
        for _ in 0..<numberOfRows {
            moveTerrainUpwards()
            let newRow = createTerrainRow(at: 0)
            tiles.insert(newRow, at: 0)
            DepthController.instance.incrementDepth()
        }
    }
    
}
