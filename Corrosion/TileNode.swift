//
//  TileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-05.
//

import SpriteKit

class TileNode: SKSpriteNode {
    var maxIntegrity: CGFloat?
    var minDepth: CGFloat?
    var maxDepth: CGFloat?
    var integrity: CGFloat?
    
    private var corrosionFactor: CGFloat = 0
    private var tileBroken = false
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        name = TERRAIN_NODE_NAME
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = TERRAIN_CATEGORY_BITMASK
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func damage(by amount: CGFloat) {
        corrosionFactor += amount
    }
    
    func update() {
        if tileBroken || integrity == nil { return }
        integrity! -= corrosionFactor
        updateColor()
        if integrity! <= 0 {
            onTileBroken()
        }
    }
    
    private func updateColor() {
        if integrity == nil || maxIntegrity == nil { return }
        let factor = integrity! / maxIntegrity!
        if factor < 1.0 {
            let changeColor = SKAction.colorize(with: .green, colorBlendFactor: 1 - factor, duration: 0)
            let changeSize = SKAction.scale(to: factor, duration: 0)
            run(SKAction.sequence([changeColor, changeSize]))
        }
    }
    
    private func onTileBroken() {
        tileBroken = true
        physicsBody = nil
        NotificationCenter.default.post(Notification(name: .onTileBroken, object: self))
    }
}

//func blendSKColors(_ color1: SKColor, _ color2: SKColor, by factor: CGFloat) -> SKColor {
//    let initialColor = SKColor.brown.toComponents()
//    let finalColor = SKColor.green.toComponents()
//    let interpolated = simd_mix(initialColor, finalColor, simd_float4(repeating: Float(factor)))
//    return interpolated.toSKColor()
//}
//
//// Extensions to allow for interpolation between color values
//extension SKColor {
//    func toComponents() -> simd_float4 {
//        var red = CGFloat(0)
//        var green = CGFloat(0)
//        var blue = CGFloat(0)
//        var alpha = CGFloat(0)
//        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        return simd_float4(x: Float(red), y: Float(green), z: Float(blue), w: Float(alpha))
//    }
//}
//
//extension simd_float4 {
//    func toSKColor() -> SKColor {
//        return SKColor(red: CGFloat(x), green: CGFloat(y), blue: CGFloat(z), alpha: CGFloat(w))
//    }
//}
