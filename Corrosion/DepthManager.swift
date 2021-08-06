//
//  DepthManager.swift
//  Corrosion
//
//  Created by Simon Robatto on 2021-08-06.
//

class DepthManager {
    
    static let instance = DepthManager()
    
    private var onDepthChanged: ((Int)->Void)?
    private var onMilestoneReached: ((Int)->Void)?
    
    private var currentDepth: Int = 0 {
        didSet {
            onDepthChanged?(currentDepth)
            if currentDepth % 1000 == 0 {
                onMilestoneReached?(currentDepth)
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
    
    func setOnDepthChangedCallback(callback: @escaping (Int)->Void) {
        onDepthChanged = callback
    }
    
    func setOnMilestoneReachedCallback(callback: @escaping (Int)->Void) {
        onMilestoneReached = callback
    }
    
}
