//
//  TTSwiftUISegmentedControlTests.swift
//  TTSegmentedControlSampleTests
//
//  Created by Igor Dumitru on 10.02.2023.
//  Copyright © 2023 Tapptitude. All rights reserved.
//

import XCTest
import SwiftUI

@testable import TTSegmentedControl

final class TTSwiftUISegmentedControlTests: XCTestCase {
    private var uiKitSegmentView: TTSegmentedControl!
    private var window: UIWindow!
    private let titles = ["Men", "Women"].map { TTSegmentedControlTitle(text: $0) }
    private var view: TTSwiftUISegmentedControl!
    
    override func setUp() {
        super.setUp()

        uiKitSegmentView = TTSegmentedControl()
        
        view = TTSwiftUISegmentedControl(titles: titles, segmentedView: uiKitSegmentView)
    }
    
    func testTitleDistribution() {
        // When
        view = view.titleDistribution(.fillEqually)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.titleDistribution, .fillEqually)
        }
    }
    
    func testSelectionViewPadding() {
        // Given
        let padding = CGSize(width: 5, height: 5)
        
        // When
        view = view.selectionViewPadding(padding)
 
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.padding, padding)
        }
    }
    
    func testIsDragEnabled() {
        // When
        view = view.isDragEnabled(false)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertFalse(self.uiKitSegmentView.isDragEnabled)
        }
    }
    
    func testAnimationOptions() {
        // Given
        let animationOptions = TTSegmentedControlAnimationOption(duration: 0.5, options: .curveEaseOut)
        
        // When
        view = view.animationOptions(animationOptions)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.animationOptions?.duration, animationOptions.duration)
            XCTAssertEqual(self.uiKitSegmentView.animationOptions?.options, animationOptions.options)
        }
    }
    
    func testIsSizeAdjustEnabled() {
        // When
        view = view.isSizeAdjustEnabled(false)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertFalse(self.uiKitSegmentView.isSizeAdjustEnabled)
        }
    }
    
    func testContainerBackgroundColor() {
        // When
        view = view.containerBackgroundColor(.black)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.containerBackgroundColor, .black)
        }
    }
    
    func testContainerGradient() {
        // When
        view = view.containerGradient(nil)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.containerGradient)
        }
    }
    
    func testSelectionViewColor() {
        // When
        view = view.selectionViewColor(.black)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColor, .black)
        }
    }
    
    func testSelectionViewGradient() {
        // When
        view = view.selectionViewGradient(nil)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.selectionViewGradient)
        }
    }
    
    func testSelectionViewShadow() {
        // Given
        let shadow = TTSegmentedControlShadow(color: .black, offset: .init(width: 1, height: 1), opacity: 1, radius: 5)
        
        // When
        view = view.selectionViewShadow(shadow)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.selectionViewShadow?.color, shadow.color)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewShadow?.offset, shadow.offset)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewShadow?.opacity, shadow.opacity)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewShadow?.radius, shadow.radius)
        }
    }
    
    func testSelectionViewFillType() {
        // When
        view = view.selectionViewFillType(.fillSegment)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.selectionViewFillType, .fillSegment)
        }
    }
    
    func testBounceAnimationOptions() {
        // When
        view = view.bounceAnimationOptions(nil)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.bounceAnimationOptions)
        }
    }
    
//    func testCornerRadius() {
//        // When
//        view = view.cornerRadius(.none)
//
//        // Then
//        XCTAssertEqual(uiKitSegmentView.cornerRadius, TTSegmentedControl.CornerRadius.none)
//    }
    
    func testCornerCurve() {
        // When
        view = view.cornerCurve(.continuous)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.cornerCurve, .continuous)
        }
    }
    
    func testIsSwitchBehaviorEnabled() {
        // When
        view = view.isSwitchBehaviorEnabled(true)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertTrue(self.uiKitSegmentView.isSwitchBehaviorEnabled)
        }
    }
    
    func testSegmentedViewDidBegin() {
        // Given
        var didBeginTouchCalled = false
        let view = view.didBeginTouch {
                didBeginTouchCalled = true
            }
        
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedViewDidBegin(uiKitSegmentView)
        
        // Then
        XCTAssertTrue(didBeginTouchCalled)
    }
    
    func testSegmentedViewDidDragAtIndex() {
        // Given
        var didDragOverItemAtIndexCalled = false
        let view = view.didDragOverItemAtIndex { index in
                didDragOverItemAtIndexCalled = true
            }
        
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedView(uiKitSegmentView, didDragAt: 0)
        
        // Then
        XCTAssertTrue(didDragOverItemAtIndexCalled)
    }

    func testSegmentedViewDidEndAtIndex() {
        // Given
        var didEndTouchAtIndexCalled = false
        let view = view.didEndTouchAtIndex { index in
                didEndTouchAtIndexCalled = true
            }
        let coordinator = view.makeCoordinator()
        
        // When
        coordinator.segmentedView(uiKitSegmentView, didEndAt: 0)
        
        // Then
        XCTAssertTrue(didEndTouchAtIndexCalled)
    }
}


extension TTSwiftUISegmentedControlTests {
    func verifyAfterDelay(_ completion: @escaping (() -> Void)) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()
        
        let timeout: Double = 0.3
        let expectation = XCTestExpectation(description: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: {
            completion()
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: timeout)
    }
}
