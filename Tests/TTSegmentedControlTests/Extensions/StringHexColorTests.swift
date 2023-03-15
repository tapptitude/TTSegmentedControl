//
//  StringHexColorTests.swift
//  
//
//  Created by Igor Dumitru on 14.03.2023.
//

import UIKit
import XCTest
@testable import TTSegmentedControl

final class StringHexColorTests: XCTestCase {
    
    func testColor() {
        // Given
        let whiteColorString = "FFFFFF"
        var red: CGFloat = 100
        var green: CGFloat = 100
        var blue: CGFloat = 100
        
        // When
        let color = whiteColorString.color
        
        // Then
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        XCTAssertEqual(red, 1)
        XCTAssertEqual(green, 1)
        XCTAssertEqual(blue, 1)
    }
}
    
