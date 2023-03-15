//
//  TTSegmentedControlBounceOptionsTests.swift
//  
//
//  Created by Igor Dumitru on 14.03.2023.
//

import XCTest
@testable import TTSegmentedControl

final class TTSegmentedControlBounceOptionsTests: XCTestCase {
    func testInit() {
        // When
        let options = TTSegmentedControlBounceOptions(springDamping: 0.4, springInitialVelocity: 0.4)
        
        // Then
        XCTAssertEqual(options.springDamping, 0.4)
        XCTAssertEqual(options.springInitialVelocity, 0.4)
    }
}
