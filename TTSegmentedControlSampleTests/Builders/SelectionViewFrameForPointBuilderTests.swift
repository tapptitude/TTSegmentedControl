//
//  SelectionViewFrameForPointBuilderTests.swift
//  SegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class SelectionViewFrameForPointBuilderTests: XCTestCase {
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
    
    private let checkSelectionViewFrame1 = CGRect(x: 2, y: 2, width: 98, height: 36)
    private let checkSelectionViewFrame2 = CGRect(x: 100, y: 2, width: 98, height: 36)
    private var selectionViewFrames: [CGRect] { [checkSelectionViewFrame1, checkSelectionViewFrame2] }
    
    private let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
    
    func testWhenMovingToRight() {
        // Given
        let point = CGPoint(x: viewBounds.midX + 10, y: viewBounds.midY)
        
        let checkSelectionViewFrame = CGRect(x: 61, y: 2, width: 98, height: 36)
        
        let builder = SelectionViewFrameForPointBuilder(
            viewBounds: viewBounds,
            point: point,
            isMovingToLeft: false,
            selectedTitleComponentsFrames: titleComponents,
            selectionViewFrames: selectionViewFrames
        )
        
        // When
        let selectionViewFrame = builder.build()
        
        // Then
        XCTAssertEqual(selectionViewFrame, checkSelectionViewFrame)
    }
    
    func testWhenMovingToLeft() {
        // Given
        let point = CGPoint(x: viewBounds.midX + 10, y: viewBounds.midY)
    
        let builder = SelectionViewFrameForPointBuilder(
            viewBounds: viewBounds,
            point: point,
            isMovingToLeft: true,
            selectedTitleComponentsFrames: titleComponents,
            selectionViewFrames: selectionViewFrames
        )
        
        let checkSelectionViewFrame = CGRect(x: 61, y: 2, width: 98, height: 36)
        
        // When
        let selectionViewFrame = builder.build()
        
        // Then
        XCTAssertEqual(selectionViewFrame, checkSelectionViewFrame)
    }
    
    func testWhenNoSectionsContainsPointBuilder() {
        // Given
        let point = CGPoint(x: viewBounds.midX + 10, y: viewBounds.midY)
        
        let builder = SelectionViewFrameForPointBuilder(
            viewBounds: viewBounds,
            point: point,
            isMovingToLeft: false,
            selectedTitleComponentsFrames: [],
            selectionViewFrames: []
        )
        
        // When
        let selectionViewFrame = builder.build()
        
        // Then
        XCTAssertNil(selectionViewFrame)
    }
}

