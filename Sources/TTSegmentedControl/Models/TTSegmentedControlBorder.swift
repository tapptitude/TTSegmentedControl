//
//  TTSegmentedControlBorder.swift
//  TTSegmentedControl
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import UIKit

public struct TTSegmentedControlBorder {
    public let color: UIColor
    public let lineWidth: CGFloat
    
    public init(color: UIColor, lineWidth: CGFloat = 1) {
        self.color = color
        self.lineWidth = lineWidth
    }
}
