//
//  CollisionController.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-12.
//

import SpriteKit

struct LiquidTileCollision {
    let liquid: SKNode
    let tile: SKNode
    let contactPoint: CGPoint
}

class CollisionController: NSObject, SKPhysicsContactDelegate {
    
    static let instance = CollisionController()
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if(nodeA.name == LIQUID_NODE_NAME) {
            NotificationCenter.default.post(
                Notification(name: .onLiquidTileCollision, object: LiquidTileCollision(liquid: nodeA, tile: nodeB, contactPoint: contact.contactPoint))
            )
        } else if(nodeB.name == LIQUID_NODE_NAME) {
            NotificationCenter.default.post(
                Notification(name: .onLiquidTileCollision, object: LiquidTileCollision(liquid: nodeB, tile: nodeA, contactPoint: contact.contactPoint))
            )
        }
    }
    
    
}
