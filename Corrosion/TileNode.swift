//
//  TileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-05.
//

import SpriteKit

class TileNode: SKShapeNode {
    private let maxIntegrity: CGFloat
    private var integrity: CGFloat
    private var corrosionFactor: CGFloat = 0
    
    init(size: CGSize, maxIntegrity: CGFloat, tileType: TileType) {
        self.maxIntegrity = maxIntegrity
        integrity = maxIntegrity
        
        super.init()
        
        path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        name = TERRAIN_NODE_NAME
        fillColor = SKColor.brown
        strokeColor = SKColor.clear
        
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = TERRAIN_CATEGORY_BITMASK
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.maxIntegrity = 0
        self.integrity = 0
        super.init(coder: aDecoder)
    }
    
    func damage(by amount: CGFloat) {
        corrosionFactor += amount
    }
    
    func update() {
        integrity -= corrosionFactor
        updateColor()
        if integrity <= 0 {
            onTileBroken()
        }
    }
    
    private func updateColor() {
        let factor = 1 - integrity / maxIntegrity
        let initialColor = SKColor.brown.toComponents()
        let finalColor = SKColor.green.toComponents()
        let interpolated = simd_mix(initialColor, finalColor, simd_float4(repeating: Float(factor)))
        fillColor = interpolated.toSKColor()
        
        run(SKAction.colorize(with: UIColor.green, colorBlendFactor: factor, duration: 0.01))
    }
    
    private func onTileBroken() {
        NotificationCenter.default.post(Notification(name: .onTileBroken, object: self))
    }
}

// Extensions to allow for interpolation between color values
extension SKColor {
    func toComponents() -> simd_float4 {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        var alpha = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return simd_float4(x: Float(red), y: Float(green), z: Float(blue), w: Float(alpha))
    }
}

extension simd_float4 {
    func toSKColor() -> SKColor {
        return SKColor(red: CGFloat(x), green: CGFloat(y), blue: CGFloat(z), alpha: CGFloat(w))
    }
}
