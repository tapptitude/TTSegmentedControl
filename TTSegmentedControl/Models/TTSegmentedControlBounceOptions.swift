//
//  TTSegmentedControlBounceOptions.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

public struct TTSegmentedControlBounceOptions {
    public let springDamping: CGFloat
    public let springInitialVelocity: CGFloat
    
    public init(
        springDamping: CGFloat = 0.7,
        springInitialVelocity: CGFloat = 0.2
    ) {
        self.springDamping = springDamping
        self.springInitialVelocity = springInitialVelocity
    }
}
