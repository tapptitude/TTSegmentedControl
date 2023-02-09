//
//  TouchFake.swift
//  SegmentedControlTests
//
//  Created by Igor Dumitru on 09.02.2023.
//

import UIKit

final class TouchFake: UITouch {
    var touchLocation = CGPoint.zero

    init(touchLocation: CGPoint = .zero) {
        self.touchLocation = touchLocation
    }
    
    override func location(in view: UIView?) -> CGPoint {
        touchLocation
    }
}

