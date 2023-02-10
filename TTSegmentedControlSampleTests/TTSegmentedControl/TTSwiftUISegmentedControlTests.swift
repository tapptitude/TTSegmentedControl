//
//  TTSwiftUISegmentedControlTests.swift
//  TTSegmentedControlSampleTests
//
//  Created by Igor Dumitru on 10.02.2023.
//  Copyright © 2023 Tapptitude. All rights reserved.
//

import XCTest
@testable import TTSegmentedControl

final class TTSwiftUISegmentedControlTests: XCTestCase {
    private let  uiKitSegmentControl = TTSegmentedControl()
    private let titles = ["Men", "Women"].map({TTSegmentedControlTitle(text: $0)})
    
    func testSegmentedViewDidBegin() {
        // Given
        var didBeginTouchCalled = false
        let view = TTSwiftUISegmentedControl(titles: titles, didBeginTouch: {
            didBeginTouchCalled = true
        })
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedViewDidBegin(uiKitSegmentControl)
        
        // Then
        XCTAssertTrue(didBeginTouchCalled)
    }
    
    func testSegmentedViewDidDragAtIndex() {
        // Given
        var didDragOverItemAtIndexCalled = false
        let view = TTSwiftUISegmentedControl(titles: titles, didDragOverItemAtIndex: { index in
            didDragOverItemAtIndexCalled = true
        })
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedView(uiKitSegmentControl, didDragAt: 0)
        
        // Then
        XCTAssertTrue(didDragOverItemAtIndexCalled)
        
    }

    func testSegmentedViewDidEndAtIndex() {
        // Given
        var didEndTouchAtIndexCalled = false
        let view = TTSwiftUISegmentedControl(titles: titles, didEndTouchAtIndex: { index in
            didEndTouchAtIndexCalled = true
        })
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedView(uiKitSegmentControl, didEndAt: 0)
        
        // Then
        XCTAssertTrue(didEndTouchAtIndexCalled)
    }
}
