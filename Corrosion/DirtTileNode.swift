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
        maxIntegrity = 100
        integrity = maxIntegrity
        minDepth = 0
        maxDepth = 100
        texture = SKTexture(imageNamed: "Dirt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
