//
//  TTSegmentedControlDelegateTests.swift
//  TTSegmentedControlSampleTests
//
//  Created by Igor Dumitru on 10.02.2023.
//  Copyright © 2023 Tapptitude. All rights reserved.
//

import XCTest
@testable import TTSegmentedControlSample

final class TTSegmentedControlDelegateTests: XCTestCase {
    private var delegate: TTSegmentedControlDelegateTestMock!
    private let segmentControl = TTSegmentedControl()
    
    override func setUp() {
        super.setUp()
        
        delegate = TTSegmentedControlDelegateTestMock()
    }
    
    func testSegmentedViewDidBegin() {
        XCTAssertNoThrow(delegate.segmentedViewDidBegin(segmentControl))
    }
    
    func testSegmentedViewDidDragAtIndex() {
        XCTAssertNoThrow(delegate.segmentedView(segmentControl, didDragAt: 0))
    }
    
    func testSegmentedViewDidEndAtIndex() {
        XCTAssertNoThrow(delegate.segmentedView(segmentControl, didEndAt: 0))
    }
}

final class TTSegmentedControlDelegateTestMock: TTSegmentedControlDelegate {}
