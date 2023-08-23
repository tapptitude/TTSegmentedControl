//
//  UIView+Border.swift
//  TTSegmentedControl
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import UIKit

extension UIView {
    func apply(_ border: TTSegmentedControlBorder) {
        layer.borderColor = border.color.cgColor
        layer.borderWidth = border.lineWidth
    }
}
