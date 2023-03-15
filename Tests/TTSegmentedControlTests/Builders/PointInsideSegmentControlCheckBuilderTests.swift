//
//  PointInsideSegmentControlCheckBuilderTests.swift
//  
//
//  Created by Igor Dumitru on 14.03.2023.
//

import XCTest
@testable import TTSegmentedControl

final class PointInsideSegmentControlCheckBuilderTests: XCTestCase {
    private let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
    
    func testPointIsInsideViewBounds() {
        // Given
        let builder = PointInsideSegmentControlCheckBuilder(viewBounds: viewBounds, point: CGPoint(x: -10, y: -10))
        
        // When
        let isPointInside = builder.build()
        
        // Then
        XCTAssertTrue(isPointInside)
    }
    
    func testPointIsOutsideViewBounds() {
        // Given
        let builder = PointInsideSegmentControlCheckBuilder(viewBounds: viewBounds, point: CGPoint(x: -50, y: -110))
        
        // When
        let isPointInside = builder.build()
        
        // Then
        XCTAssertFalse(isPointInside)
    }
}
    
