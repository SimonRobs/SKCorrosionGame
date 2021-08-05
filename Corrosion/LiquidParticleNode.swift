//
//  LiquidParticleNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-05.
//

import SpriteKit

class LiquidParticleNode: SKShapeNode {
    
    private var onRemovedFromParent: ()->Void
    
    init(radius: CGFloat, onRemovedFromParent: @escaping ()->Void) {
        self.onRemovedFromParent = onRemovedFromParent
        super.init()
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: radius, height: radius)), transform: nil)
        
        name = LIQUID_NODE_NAME
        strokeColor = SKColor.clear
        fillColor = SKColor.green.withAlphaComponent(0.8)
        
        physicsBody = SKPhysicsBody.init(circleOfRadius: radius / 2)
        physicsBody?.categoryBitMask = LIQUID_CATEGORY_BITMASK
        physicsBody?.contactTestBitMask = TERRAIN_CATEGORY_BITMASK
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        onRemovedFromParent()
    }
}
