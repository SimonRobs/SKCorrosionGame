//
//  LiquidEmitterNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-03.
//

import SpriteKit

class LiquidEmitterNode: SKNode {
    private static let PARTICLE_RADIUS: CGFloat = 6
    
    private var center: CGPoint?
    private var isEmitting = false
    
    init(scene: SKScene) {
        super.init()
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    private static func createParticleNode() -> SKShapeNode {
        let particleNode = SKShapeNode.init(circleOfRadius: PARTICLE_RADIUS)
        
        particleNode.name = LIQUID_NODE_NAME
        particleNode.strokeColor = SKColor.clear
        particleNode.fillColor = SKColor.green.withAlphaComponent(0.8)
        particleNode.physicsBody = SKPhysicsBody.init(circleOfRadius: PARTICLE_RADIUS / 2)
        particleNode.physicsBody?.categoryBitMask = LIQUID_CATEGORY_BITMASK
        particleNode.physicsBody?.contactTestBitMask = TERRAIN_CATEGORY_BITMASK
        particleNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                          SKAction.fadeOut(withDuration: 0.3),
                                          SKAction.removeFromParent()]))
        
        return particleNode
    }
    
    func startEmitter(at position: CGPoint) {
        isEmitting = true
        center = position
    }
    
    func updateEmitterCenter(_ newCenter: CGPoint) {
        center = newCenter
    }
    
    func stopEmitter() {
        isEmitting = false
        center = nil
    }
    
    func emit() {
        if(!isEmitting) { return }
        if center == nil { return }
        let particle = LiquidEmitterNode.createParticleNode()
        particle.position = center!
        scene?.addChild(particle)
    }
    
    
}
