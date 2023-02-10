//
//  UIView+Shadow.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 31.01.2023.
//

import UIKit

extension UIView {
    func apply(_ shadow: TTSegmentedControlShadow) {
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOffset = shadow.offset
        layer.shadowOpacity = shadow.opacity
        layer.shadowRadius = shadow.radius
        layer.masksToBounds = false
    }
}
