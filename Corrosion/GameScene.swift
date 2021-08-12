//
//  GameScene.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-02.
//

import SpriteKit

class GameScene: SKScene {
    
    private let balanceLabel = SKLabelNode()
    private var currentBalance = 0 {
        didSet {
            balanceLabel.text = "Balance: \(currentBalance)$"
        }
    }
    
    private let depthLabel = SKLabelNode()
    
    private var terrainNode: TerrainNode?
    private var liquidEmitterNodes: [UITouch: LiquidEmitterNode] = [:]
    
    override func didMove(to view: SKView) {
        initializeSceneVariables()
        createSceneContent()
        addNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initializeSceneVariables() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = CollisionController.instance
    }
    
    func createSceneContent() {
        setupBalanceLabel()
        setupDepthLabel()
        
        terrainNode = TerrainNode(scene: self)
        terrainNode?.createTerrain()
        terrainNode?.onTileBrokenCallback = {
            self.currentBalance += 1
        }
    }
    
    func setupBalanceLabel() {
        balanceLabel.text = "Balance: \(currentBalance) $"
        let xPos = frame.maxX - balanceLabel.frame.size.width / 2
        let yPos = frame.maxY - balanceLabel.frame.size.height*2
        balanceLabel.position = CGPoint(x: xPos, y: yPos)
        balanceLabel.fontSize = 18
        balanceLabel.fontName = "Helvetica"
        balanceLabel.color = SKColor.white
        addChild(balanceLabel)
    }
    
    func setupDepthLabel() {
        let depthManager = DepthController.instance
        depthLabel.text = "Depth: \(depthManager.getDepth()) m"
        let xPos = depthLabel.frame.size.width / 2
        let yPos = frame.maxY - depthLabel.frame.size.height*2
        depthLabel.position = CGPoint(x: xPos, y: yPos)
        depthLabel.fontSize = 18
        depthLabel.fontName = "Helvetica"
        depthLabel.color = SKColor.white
        addChild(depthLabel)
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDepthChanged), name: .onDepthChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLiquidTileCollision), name: .onLiquidTileCollision, object: nil)
    }
    
    @objc private func onDepthChanged(_ notification: Notification) {
        guard let depth = notification.object as? CGFloat else { return }
        self.depthLabel.text = "Depth: \(depth) m"
    }
    
    @objc private func onLiquidTileCollision(_ notification: Notification) {
        if let collisionData = notification.object as? LiquidTileCollision {
            triggerPoisonParticles(contactPoint: collisionData.contactPoint)
        }
    }
    
    private func triggerPoisonParticles(contactPoint: CGPoint) {
        guard let particles = SKEmitterNode(fileNamed: "Poison") else { return }
        particles.position = contactPoint
        addChild(particles)
        
        let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()])
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
