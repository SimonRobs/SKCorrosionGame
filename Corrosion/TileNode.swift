//
//  TileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-05.
//

import SpriteKit

class TileNode: SKShapeNode {
    private static let MAX_INTEGRITY: CGFloat = 100
    private let CORROSION_INCREMENT: CGFloat = 5
    private var integrity: CGFloat = MAX_INTEGRITY
    private var corrosionFactor: CGFloat = 0
    
    public var onTileBroken: (()->Void)?
    
    func damage() {
        corrosionFactor += CORROSION_INCREMENT
    }
    
    func update() {
        integrity -= corrosionFactor
        let factor = 1 - integrity / TileNode.MAX_INTEGRITY
        let initialColor = SKColor.brown.toComponents()
        let finalColor = SKColor.green.toComponents()
        let interpolated = simd_mix(initialColor, finalColor, simd_float4(repeating: Float(factor)))
        fillColor = interpolated.toSKColor()
        
        run(SKAction.colorize(with: UIColor.green, colorBlendFactor: factor, duration: 0.01))
        if integrity <= 0 {
            onTileBroken?()
        }
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
