//
//  DelayedWorkItemTests.swift
//  SegmentedControlTests
//
//  Created by Igor Dumitru on 08.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class DelayedWorkItemTests: XCTestCase {
    private var delayedWorkItem: DelayedWorkItem!
    
    private var isDelayedWorkItemBodyCalled: Bool = false
    
    override func setUp() {
        super.setUp()
        
        delayedWorkItem = DelayedWorkItem(delay: 0.1, body: { [weak self] in
            self?.isDelayedWorkItemBodyCalled = true
        })
    }
    
    override func tearDown() {
        super.tearDown()
        
        isDelayedWorkItemBodyCalled = false
    }
    
    func testExecute() {
        // Given
        let expectation = XCTestExpectation(description: "")
  
        // When
        delayedWorkItem.execute()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            guard let `self` = self else { return }
            XCTAssertTrue(self.isDelayedWorkItemBodyCalled)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testCancel() {
        // Given
        let expectation = XCTestExpectation(description: "")
        delayedWorkItem.execute()
        
        // When
        delayedWorkItem.cancel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            guard let `self` = self else { return }
            XCTAssertFalse(self.isDelayedWorkItemBodyCalled)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.3)
    }
}
