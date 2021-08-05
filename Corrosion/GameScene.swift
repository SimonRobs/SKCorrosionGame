//
//  GameScene.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-02.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var balanceLabel = SKLabelNode()
    private var currentBalance = 0 {
        didSet {
            balanceLabel.text = "Balance: \(currentBalance)$"
        }
    }
    
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
        setupBalanceLabel()
        
        terrainNode = TerrainNode(scene: self)
        terrainNode?.createTerrain()
        terrainNode?.onTileBrokenCallback = {
            self.currentBalance += 1
        }
    }
    
    func setupBalanceLabel() {
        balanceLabel.text = "Balance: \(currentBalance)$"
        let xPos = frame.maxX - balanceLabel.frame.size.width / 2
        let yPos = frame.maxY - balanceLabel.frame.size.height*2
        balanceLabel.position = CGPoint(x: xPos, y: yPos)
        balanceLabel.fontSize = 18
        balanceLabel.fontName = "Helvetica"
        balanceLabel.color = SKColor.white
        addChild(balanceLabel)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if(nodeA.name == "liquid") {
            handleLiquidTerrainCollision(liquid: nodeA, tile: nodeB, contactPoint: contact.contactPoint)
        } else if(nodeB.name == "liquid") {
            handleLiquidTerrainCollision(liquid: nodeB, tile: nodeA, contactPoint: contact.contactPoint)
        }
    }
    
    func handleLiquidTerrainCollision(liquid: SKNode, tile: SKNode, contactPoint: CGPoint) {
        terrainNode?.handleTileCollision(liquid: liquid, tile: tile)
        triggerPoisonParticles(contactPoint: contactPoint)
    }
    
    func triggerPoisonParticles(contactPoint: CGPoint) {
        guard let particles = SKEmitterNode(fileNamed: "Poison") else { return }
        particles.position = contactPoint
        addChild(particles)
        
        let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
        particles.run(removeAfterDead)
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
        terrainNode?.updateTerrain()
        
    }
}
