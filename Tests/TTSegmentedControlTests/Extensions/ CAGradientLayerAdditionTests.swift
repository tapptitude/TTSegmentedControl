//
//  CAGradientLayerAdditionTests.swift
//  
//
//  Created by Igor Dumitru on 14.03.2023.
//

import UIKit
import XCTest
@testable import TTSegmentedControl

final class CAGradientLayerAdditionTests: XCTestCase {
    private var gradientLayer: CAGradientLayer!
    
    override func setUp() {
        super.setUp()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    func testApplyGradient() {
        // Given
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 1, y: 1)
        let colors = [UIColor.black, UIColor.white]
        let gradient = TTSegmentedControlGradient(
            locations: nil,
            startPoint: startPoint,
            endPoint: endPoint,
            colors: colors
        )
        
        // When
        gradientLayer.apply(gradient)
        
        // Then
        XCTAssertNil(gradientLayer.locations)
        XCTAssertEqual(gradientLayer.startPoint, gradient.startPoint)
        XCTAssertEqual(gradientLayer.endPoint, gradient.endPoint)
        XCTAssertEqual(gradientLayer.colors?.first as! CGColor, gradient.colors.first?.cgColor)
        XCTAssertEqual(gradientLayer.colors?.last as! CGColor, gradient.colors.last?.cgColor)
    }
}
