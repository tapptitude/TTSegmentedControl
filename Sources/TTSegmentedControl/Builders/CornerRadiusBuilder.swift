//
//  CornerRadiusBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

struct CornerRadiusBuilder {
    private let frame: CGRect
    private let cornerRadius: TTSegmentedControl.CornerRadius
    
    init(frame: CGRect, cornerRadius: TTSegmentedControl.CornerRadius) {
        self.frame = frame
        self.cornerRadius = cornerRadius
    }
}

extension CornerRadiusBuilder {
    func build() -> CGFloat {
        switch self.cornerRadius {
        case .none:
            return 0
        case .maximum:
            return 0.5 * frame.height
        case .constant(let value):
            return max(0, min(value, 0.5 * frame.height))
        }
    }
}
