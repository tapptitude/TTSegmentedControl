//
//  CAGradientLayer+Addition.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import UIKit

extension CAGradientLayer {
    func apply(_ gradient: TTSegmentedControlGradient) {
        locations = gradient.locations
        startPoint = gradient.startPoint
        endPoint = gradient.endPoint
        colors = gradient.colors.map({$0.cgColor})
    }
}
