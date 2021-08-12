//
//  DepthManager.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-06.
//

import Foundation

class DepthController {
    
    static let instance = DepthController()
    
    private var currentDepth: Int = 0 {
        didSet {
            NotificationCenter.default.post(Notification(name: .onDepthChanged, object: currentDepth))
            if currentDepth % 10_000 == 0 {
                NotificationCenter.default.post(Notification(name: .onMilestoneReached, object: currentDepth))
            }
        }
    }
    
    func incrementDepth() {
        currentDepth += 1
    }
    
    func setDepth(depth: Int) {
        currentDepth = depth
    }
    
    func getDepth() -> Int {
        return currentDepth
    }
}
