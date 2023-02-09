//
//  CornerRadiusBuilderTests.swift
//  SegmentedControlTests
//
//  Created by Igor Dumitru on 08.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class CornerRadiusBuilderTests: XCTestCase {
    
    func testNegativeCornerRadius() {
        // Given
        let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)

        let builder = CornerRadiusBuilder(
            frame: viewBounds,
            cornerRadius: -1
        )
        
        // When
        let cornerRadius = builder.build()
        
        // Then
        XCTAssertEqual(cornerRadius, 0.5 * viewBounds.height)
    }
    
    func testVeryBigCornerRadius() {
        // Given
        let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)

        let builder = CornerRadiusBuilder(
            frame: viewBounds,
            cornerRadius: 1000
        )
        
        // When
        let cornerRadius = builder.build()
        
        // Then
        XCTAssertEqual(cornerRadius, 0.5 * viewBounds.height)
    }
    
    func testNormalCornerRadius() {
        // Given
        let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)

        let builder = CornerRadiusBuilder(
            frame: viewBounds,
            cornerRadius: 5
        )
        
        // When
        let cornerRadius = builder.build()
        
        // Then
        XCTAssertEqual(cornerRadius, 5)
    }
}

