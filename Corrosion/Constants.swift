//
//  GlobalConstants.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-03.
//

import Foundation

// MARK: - SpriteKit Constants
let TERRAIN_NODE_NAME = "terrain"
let LIQUID_NODE_NAME = "liquid"

let LIQUID_CATEGORY_BITMASK: UInt32 = 0b0010
let TERRAIN_CATEGORY_BITMASK: UInt32 = 0b0001

// MARK: - Asset Name Constants

// MARK: - NotificationCenter Name Constants
extension Notification.Name {
    static let onTileBroken = Notification.Name("Event::TileBroken")
    static let onDepthChanged = Notification.Name("Event::DepthChanged")
    static let onMilestoneReached = Notification.Name("Event::MilestoneReached")
    
    static let onLiquidTileCollision = Notification.Name("Collision::Liquid-Tile")
}
