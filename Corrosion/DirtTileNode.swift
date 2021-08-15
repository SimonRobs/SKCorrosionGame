//
//  DirtTileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-12.
//

import SpriteKit

class DirtTileNode: TileNode {
    override init(size: CGSize) {
        super.init(size: size)
        maxIntegrity = 200
        integrity = maxIntegrity
        minDepth = 0
        maxDepth = 100
        particleEmitter = SKEmitterNode(fileNamed: "Poison")
        texture = SKTexture(imageNamed: "Dirt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
