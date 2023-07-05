//
//  TTSegmentedControlGradient.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import UIKit

public struct TTSegmentedControlGradient {
    public let locations: [NSNumber]?
    public let startPoint: CGPoint
    public let endPoint: CGPoint
    public let colors: [UIColor]
    
    public init(
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
        colors: [UIColor] = [.yellow, .purple]
    ) {
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colors = colors
    }
}

