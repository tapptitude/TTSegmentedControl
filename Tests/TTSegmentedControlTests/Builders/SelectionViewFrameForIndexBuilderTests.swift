//
//  SelectionViewFrameForIndexBuilderTexts.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class SelectionViewFrameForIndexBuilderTests: XCTestCase {
    
    func testBuilder() {
        // Given
        let titleComponents1 = TitleComponentFrame(
            text: CGRect(x: 41, y: 13.5, width: 20, height: 13),
            image: CGRect(x: 61, y: 20, width: 0, height: 0),
            total: CGRect(x: 41, y: 0, width: 20, height: 40)
        )
        
        let titleComponents2 = TitleComponentFrame(
            text: CGRect(x: 139, y: 13.5, width: 20, height: 13),
            image: CGRect(x: 159, y: 20, width: 0, height: 0),
            total: CGRect(x: 139, y: 0, width: 20, height: 40)
        )
        let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
        let titleComponents = [titleComponents1, titleComponents2]
        let padding: CGSize = .init(width: 2, height: 2)
        let selectionViewFillType: TTSegmentedControl.SelectionViewFillType = .fillText
        
        let builder = SelectionViewFrameForIndexBuilder(
            viewBounds: viewBounds,
            defaultTitleComponentsFrames: titleComponents,
            selectedTitleComponentsFrames: titleComponents,
            index: 1,
            padding: padding,
            selectionViewFillType: selectionViewFillType
        )
        
        let checkSelectionViewFrame = CGRect(x: 100, y: 2, width: 98, height: 36)
        
        // When
        let selectionViewFrame = builder.build()
        
        // Then
        XCTAssertEqual(selectionViewFrame, checkSelectionViewFrame)
    }
}

