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
    
    func testContainerColorTypeWithColor() {
        // When
        view = view.containerColorType(.color(value: .black))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.containerColorType.color, .black)
        }
    }
    
    func testContainerColorTypeWithGradient() {
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
        view = view.containerColorType(.gradient(value: gradient))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.containerColorType.gradient?.locations)
            XCTAssertEqual(self.uiKitSegmentView.containerColorType.gradient?.startPoint, gradient.startPoint)
            XCTAssertEqual(self.uiKitSegmentView.containerColorType.gradient?.endPoint, gradient.endPoint)
            XCTAssertEqual(self.uiKitSegmentView.containerColorType.gradient!.colors.first, gradient.colors.first)
            XCTAssertEqual(self.uiKitSegmentView.containerColorType.gradient!.colors.last, gradient.colors.last)
        }
    }
    
    func testContainerViewBorder() {
        // Given
        let border = TTSegmentedControlBorder(color: .red, lineWidth: 3)
        
        // When
        view = view.containerViewBorder(border)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let self else { return }
            XCTAssertEqual(self.uiKitSegmentView.containerViewBorder?.color, border.color)
            XCTAssertEqual(self.uiKitSegmentView.containerViewBorder?.lineWidth, border.lineWidth)
        }
    }
    
    func testSelectionViewColorTypeWithColor() {
        // When
        view = view.selectionViewColorType(.color(value: .black))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColorType.color, .black)
        }
    }
    
    func testSelectionViewColorTypeWithGradient() {
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
        view = view.selectionViewColorType(.gradient(value: gradient))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.selectionViewColorType.gradient?.locations)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColorType.gradient?.startPoint, gradient.startPoint)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColorType.gradient?.endPoint, gradient.endPoint)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColorType.gradient?.colors.first, gradient.colors.first)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewColorType.gradient?.colors.last, gradient.colors.last)
        }
    }
    
    func testSwitchSecondSelectionViewColorTypeWithColor() {
        // When
        view = view.isSwitchBehaviorEnabled(true).switchSecondSelectionViewColorType(.color(value: .white))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertEqual(self.uiKitSegmentView.switchSecondSelectionViewColorType?.color, .white)
        }
    }
    
    func testSwitchSelectionViewColorTypeWithGradient() {
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
        view = view.isSwitchBehaviorEnabled(true).switchSecondSelectionViewColorType(.gradient(value: gradient))
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let `self` = self else { return }
            XCTAssertNil(self.uiKitSegmentView.switchSecondSelectionViewColorType?.gradient?.locations)
            XCTAssertEqual(self.uiKitSegmentView.switchSecondSelectionViewColorType?.gradient?.startPoint, gradient.startPoint)
            XCTAssertEqual(self.uiKitSegmentView.switchSecondSelectionViewColorType?.gradient?.endPoint, gradient.endPoint)
            XCTAssertEqual(self.uiKitSegmentView.switchSecondSelectionViewColorType?.gradient?.colors.first, gradient.colors.first)
            XCTAssertEqual(self.uiKitSegmentView.switchSecondSelectionViewColorType?.gradient?.colors.last, gradient.colors.last)
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
    
    func testSelectionViewBorder() {
        // Given
        let border = TTSegmentedControlBorder(color: .red, lineWidth: 3)
        
        // When
        view = view.selectionViewBorder(border)
        
        // Then
        verifyAfterDelay { [weak self] in
            guard let self else { return }
            XCTAssertEqual(self.uiKitSegmentView.selectionViewBorder?.color, border.color)
            XCTAssertEqual(self.uiKitSegmentView.selectionViewBorder?.lineWidth, border.lineWidth)
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
