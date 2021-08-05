//
//  LiquidEmitterNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-03.
//

import SpriteKit

class LiquidEmitterNode: SKNode {
    private let PARTICLE_RADIUS: CGFloat = 6
    private let MAX_PARTICLES = 20
    
    private var center: CGPoint?
    private var currentParticleCount = 0
    private var isEmitting = false
    
    init(scene: SKScene) {
        super.init()
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    private func createParticleNode() -> LiquidParticleNode {
        let particleNode = LiquidParticleNode(radius: PARTICLE_RADIUS) {
            self.currentParticleCount -= 1
        }
        
//        particleNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                          SKAction.fadeOut(withDuration: 0.3),
//                                          SKAction.removeFromParent()]))
        
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
//        if currentParticleCount >= MAX_PARTICLES { return }
        let particle = createParticleNode()
        particle.position = center!
        scene?.addChild(particle)
        currentParticleCount += 1
    }
    
    
}
