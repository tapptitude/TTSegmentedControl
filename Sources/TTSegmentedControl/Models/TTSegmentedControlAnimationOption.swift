//
//  TTSegmentedControlAnimationOption.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import UIKit

public struct TTSegmentedControlAnimationOption {
    public let duration: TimeInterval
    public let options: UIView.AnimationOptions
    
    public init(
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .curveEaseInOut
    ) {
        self.duration = duration
        self.options = options
    }
}
