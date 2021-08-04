//
//  GameScene.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-02.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var terrainNode: TerrainNode?
    private var liquidEmitterNodes: [UITouch: LiquidEmitterNode] = [:]
    
    override func didMove(to view: SKView) {
        initializeSceneVariables()
        createSceneContent()
    }
    
    func initializeSceneVariables() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
    }
    
    func createSceneContent() {
        terrainNode = TerrainNode(scene: self)
        terrainNode?.createTerrain()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if(nodeA.name == "liquid") {
            terrainNode?.handleTileCollision(liquid: nodeA, tile: nodeB)
        } else if(nodeB.name == "liquid") {
            terrainNode?.handleTileCollision(liquid: nodeB, tile: nodeA)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            liquidEmitterNodes[touch] = LiquidEmitterNode(scene: self)
            liquidEmitterNodes[touch]?.startEmitter(at: touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            liquidEmitterNodes[touch]?.updateEmitterCenter(touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            liquidEmitterNodes.removeValue(forKey: touch)
            liquidEmitterNodes[touch]?.stopEmitter()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            liquidEmitterNodes.removeValue(forKey: touch)
            liquidEmitterNodes[touch]?.stopEmitter()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for emitter in liquidEmitterNodes {
            emitter.value.emit()
        }
        
    }
}
