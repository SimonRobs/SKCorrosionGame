//
//  TileNode.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-05.
//

import SpriteKit

class TileNode: SKSpriteNode {
    private let maxIntegrity: CGFloat
    private var integrity: CGFloat
    private var corrosionFactor: CGFloat = 0
    
    init(size: CGSize, maxIntegrity: CGFloat) {
        self.maxIntegrity = maxIntegrity
        integrity = maxIntegrity
        let texture = SKTexture(imageNamed: "Dirt")
        super.init(texture: texture, color: .clear, size: size)
        
        name = TERRAIN_NODE_NAME
        
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
        let changeColor = SKAction.colorize(with: .green, colorBlendFactor: factor, duration: 0.01)
        let changeSize = SKAction.scale(by: 1 - factor, duration: 0.01)
        run(SKAction.sequence([changeColor, changeSize]))
    }
    
    private func onTileBroken() {
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
