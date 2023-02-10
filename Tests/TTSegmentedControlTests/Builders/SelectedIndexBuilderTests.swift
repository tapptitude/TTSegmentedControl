//
//  SelectedIndexBuilderTests.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class SelectedIndexBuilderTests: XCTestCase {
    private let titleComponents1 = TitleComponentFrame(
        text: CGRect(x: 41, y: 13.5, width: 20, height: 13),
        image: CGRect(x: 61, y: 20, width: 0, height: 0),
        total: CGRect(x: 41, y: 0, width: 20, height: 40)
    )
    
    private let titleComponents2 = TitleComponentFrame(
        text: CGRect(x: 139, y: 13.5, width: 20, height: 13),
        image: CGRect(x: 159, y: 20, width: 0, height: 0),
        total: CGRect(x: 139, y: 0, width: 20, height: 40)
    )
    private var titleComponents: [TitleComponentFrame] { [titleComponents1, titleComponents2] }
    private let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
    private let padding: CGSize = .init(width: 2, height: 2)
    private let titleDistribution: TTSegmentedControl.TitleDistribution = .equalSpacing
    
    func testBuilder() {
        // Given
        let point: CGPoint = .init(x: viewBounds.midX + 10, y: viewBounds.midY)
        
        let builder = SelectedIndexBuilder(
            viewBounds: viewBounds,
            cornerRadius: .zero,
            defaultTitleComponentsFrames: titleComponents,
            selectedTitleComponentsFrames: titleComponents,
            point: point,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let index = builder.build()
        
        // Then
        XCTAssertEqual(index, 1)
    }
    
    func testWhenXIsLessThanZero() {
        // Given
        let point: CGPoint = .init(x: -10, y: viewBounds.midY)
        
        let builder = SelectedIndexBuilder(
            viewBounds: viewBounds,
            cornerRadius: .zero,
            defaultTitleComponentsFrames: titleComponents,
            selectedTitleComponentsFrames: titleComponents,
            point: point,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let index = builder.build()
        
        // Then
        XCTAssertEqual(index, 0)
    }
    
    func testWhenXIsMoreThanBoundsWidth() {
        // Given
        let point: CGPoint = .init(x: viewBounds.width + 10, y: viewBounds.midY)
        
        let builder = SelectedIndexBuilder(
            viewBounds: viewBounds,
            cornerRadius: .zero,
            defaultTitleComponentsFrames: titleComponents,
            selectedTitleComponentsFrames: titleComponents,
            point: point,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let index = builder.build()
        
        // Then
        XCTAssertEqual(index, 1)
    }
    
    func testWhenNoTitles() {
        // Given
        let point: CGPoint = .init(x: 20, y: viewBounds.midY)
        
        let builder = SelectedIndexBuilder(
            viewBounds: viewBounds,
            cornerRadius: .zero,
            defaultTitleComponentsFrames: [],
            selectedTitleComponentsFrames: [],
            point: point,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let index = builder.build()
        
        // Then
        XCTAssertEqual(index, 0)
    }
}
