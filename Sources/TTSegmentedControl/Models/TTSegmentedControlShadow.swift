//
//  TTSegmentedControlShadow.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 30.01.2023.
//

import UIKit

public struct TTSegmentedControlShadow {
    public let color: UIColor
    public let offset: CGSize
    public let innerOffset: CGSize
    public let opacity: Float
    public let radius: CGFloat
    
    public init(
        color: UIColor = .black,
        offset: CGSize = .init(width: 0, height: 1),
        innerOffset: CGSize = .init(width: -1, height: -1),
        opacity: Float = 0.6,
        radius: CGFloat = 3.0
    ) {
        self.color = color
        self.offset = offset
        self.innerOffset = innerOffset
        self.opacity = opacity
        self.radius = radius
    }
}
