//
//  PointInsideSegmentControlCheckBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.03.2023.
//  Copyright © 2023 Tapptitude. All rights reserved.
//

import Foundation

struct PointInsideSegmentControlCheckBuilder {
    private let viewBounds: CGRect
    private let point: CGPoint
    
    init(
        viewBounds: CGRect,
        point: CGPoint
    ) {
        self.viewBounds = viewBounds
        self.point = point
    }
}

extension PointInsideSegmentControlCheckBuilder {
    func build() -> Bool {
        let frame = CGRect(
            x: viewBounds.origin.x - 2 * viewBounds.height,
            y: viewBounds.origin.y - 2 * viewBounds.height,
            width: viewBounds.width + 4 * viewBounds.height,
            height: viewBounds.height + 4 * viewBounds.height
        )
        return frame.contains(point)
    }
}
