//
//  TestablePanGestureRecognizer.swift
//  
//
//  Created by Igor Dumitru on 15.03.2023.
//

import UIKit

final class TestablePanGestureRecognizer: UIPanGestureRecognizer {
    let testTarget: AnyObject?
    let testAction: Selector?
    
    private(set) var testLocation: CGPoint?
    
    override init(target: Any?, action: Selector?) {
        testTarget = target as AnyObject?
        testAction = action
        super.init(target: target, action: action)
    }
    
    func perfomTouch(location: CGPoint?, state: UIGestureRecognizer.State) {
        testLocation = location
        self.state = state
        guard let testAction = testAction else { return }
        testTarget?.perform(testAction, on: .current, with: self, waitUntilDone: true)
    }
    
    override func location(in view: UIView?) -> CGPoint {
        if let testLocation = testLocation {
            return testLocation
        }
        return super.location(in: view)
    }
}
