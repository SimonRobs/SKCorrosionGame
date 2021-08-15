//
//  StoneTileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-15.
//

import SpriteKit

class StoneTileNode: TileNode {
    override init(size: CGSize) {
        super.init(size: size)
        maxIntegrity = 500
        integrity = maxIntegrity
        minDepth = 50
        maxDepth = 1000
        texture = SKTexture(imageNamed: "Stone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
