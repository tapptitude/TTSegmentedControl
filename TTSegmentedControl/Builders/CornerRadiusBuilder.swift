//
//  CornerRadiusBuilder.swift
//  SegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

struct CornerRadiusBuilder {
    private let frame: CGRect
    private let cornerRadius: CGFloat
    
    init(frame: CGRect, cornerRadius: CGFloat) {
        self.frame = frame
        self.cornerRadius = cornerRadius
    }
}

extension CornerRadiusBuilder {
    func build() -> CGFloat {
        let maxCornerRadius = 0.5 * min(frame.height, frame.width)
        let minCornerRadius: CGFloat = 0
        let cornerRadius = (self.cornerRadius < 0) ? maxCornerRadius : min(maxCornerRadius, self.cornerRadius)
        return min(max(minCornerRadius, cornerRadius), maxCornerRadius)
    }
}
