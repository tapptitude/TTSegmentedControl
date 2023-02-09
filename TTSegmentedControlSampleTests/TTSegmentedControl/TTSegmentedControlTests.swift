//
//  TTSegmentedControlTests.swift
//  SegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class TTSegmentedControlTests: XCTestCase {
    private var delegate: TTSegmentedControlDelegateMock!
    private var segmentedView: TTSegmentedControl!
    
    override func setUp() {
        super.setUp()
        
        delegate = TTSegmentedControlDelegateMock()
        segmentedView = TTSegmentedControl()
        segmentedView.delegate = delegate
        segmentedView.titles = ["Men", "Women"].map({TTSegmentedControlTitle(text: $0)})
        //        segmentedView.frame = CGRect(x: 0, y: 0, width: 1, height: 50)
    }
    
    func testTouchesBeganWithEventWithoutTouches() {
        // When
        segmentedView.touchesBegan(Set(), with: nil)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesBeganWithEvent() {
        // Given
        let touch = TouchFake()
        
        // When
        segmentedView.touchesBegan(Set([touch]), with: nil)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesBeganWithEventForSwitches() {
        // Given
        let startTouch = TouchFake()
        
        // When
        segmentedView.touchesBegan(Set([startTouch]), with: nil)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
        XCTAssertTrue(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesMovedWithEvent() {
        // Given
        let touch = TouchFake()
        
        // When
        segmentedView.touchesMoved(Set([touch]), with: nil)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewdidDragAtIndexCalled)
    }
    
    func testTouchesMovedWithEventWithoutTouches() {
        // When
        segmentedView.touchesMoved(Set(), with: nil)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewdidDragAtIndexCalled)
    }
    
    func testTouchesMovedWithEventWhenDragIsDisabled() {
        // Given
        segmentedView.isDragEnabled = false
        let touch = TouchFake()
        
        // When
        segmentedView.touchesMoved(Set([touch]), with: nil)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesEndedWithEvent() {
        // Given
        let startTouch = TouchFake()
        let endTouch = TouchFake(touchLocation: CGPoint(x: 1000, y: 5))
        segmentedView.isSwitchBehaviorEnabled = false
        segmentedView.touchesBegan(Set([startTouch]), with: nil)
        
        let selectionViewFrame = segmentedView.selectionView.frame
        let selectedIndex = segmentedView.selectedIndex
        
        segmentedView.touchesMoved(Set([endTouch]), with: nil)
        
        // When
        segmentedView.touchesEnded(Set([endTouch]), with: nil)
        
        // Then
        XCTAssertNotEqual(segmentedView.selectedIndex, selectedIndex)
        XCTAssertNotEqual(segmentedView.selectionView.frame, selectionViewFrame)
        XCTAssertTrue(delegate.segmentedViewDidEndAtIndexCalled)
    }
    
    func testTouchesEndedWithEventWithoutTouchesAndDragDisabled() {
        // Given
        let touch = TouchFake(touchLocation: CGPoint(x: 1000, y: 5))
        segmentedView.touchesBegan(Set([touch]), with: nil)
        let selectionViewFrame = segmentedView.selectionView.frame
        let selectedIndex = segmentedView.selectedIndex
        
        // When
        segmentedView.touchesEnded(Set(), with: nil)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, selectedIndex)
        XCTAssertEqual(segmentedView.selectionView.frame, selectionViewFrame)
        XCTAssertTrue(delegate.segmentedViewDidEndAtIndexCalled)
    }
    
    func testTouchesCancelledWithEvent() {
        // Given
        let startTouch = TouchFake()
        let endTouch = TouchFake(touchLocation: CGPoint(x: 1000, y: 5))
        segmentedView.isSwitchBehaviorEnabled = false
        segmentedView.touchesBegan(Set([startTouch]), with: nil)
        
        let selectionViewFrame = segmentedView.selectionView.frame
        let selectedIndex = segmentedView.selectedIndex
        
        segmentedView.touchesMoved(Set([endTouch]), with: nil)
        
        // When
        segmentedView.touchesCancelled(Set([endTouch]), with: nil)
        
        // Then
        XCTAssertNotEqual(segmentedView.selectedIndex, selectedIndex)
        XCTAssertNotEqual(segmentedView.selectionView.frame, selectionViewFrame)
        XCTAssertTrue(delegate.segmentedViewDidEndAtIndexCalled)
    }
    
    func testView() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertEqual(segmentedView.subviews.count, 3)
        XCTAssertEqual(segmentedView.backgroundColor, .clear)
        XCTAssertTrue(segmentedView.isUserInteractionEnabled)
        XCTAssertFalse(segmentedView.clipsToBounds)
    }
    
    func testDefaultStateView() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertEqual(segmentedView.defaultStateView.frame, segmentedView.bounds)
        XCTAssertFalse(segmentedView.defaultStateView.isUserInteractionEnabled)
        XCTAssertTrue(segmentedView.defaultStateView.clipsToBounds)
        XCTAssertEqual(segmentedView.defaultStateView.autoresizingMask, [.flexibleWidth, .flexibleHeight])
        XCTAssertEqual(segmentedView.defaultStateView.backgroundColor, .white)
        XCTAssertEqual(segmentedView.defaultStateView.layer.cornerRadius, 0.5 * segmentedView.defaultStateView.frame.height)
    }
    
    func testContainerGradientLayer() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertTrue(((segmentedView.defaultStateView.layer.sublayers?.contains(segmentedView.defaultStateViewGradientLayer)) != nil))
        XCTAssertTrue(segmentedView.defaultStateViewGradientLayer.isHidden)
        XCTAssertEqual(segmentedView.defaultStateViewGradientLayer.frame, segmentedView.defaultStateView.bounds)
    }
    
    func testDefaultStateLabels() {
        // Given
        let titles = segmentedView.titles
        
        // When
        segmentedView.layoutSubviews()
        
        // Then
        let labels = segmentedView.defaultStateView.subviews.compactMap({$0 as? UILabel})
        XCTAssertEqual(labels.count, 2)
        
        for index in 0..<labels.count {
            let label = labels[index]
            XCTAssertEqual(label.tag, index + 1)
            XCTAssertEqual(label.textAlignment, .center)
            XCTAssertEqual(label.attributedText, titles[index].availableDefaultAttributedText)
        }
    }
    
    func testDefaultStateImagesViews() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        let imageViews = segmentedView.defaultStateView.subviews.compactMap({$0 as? UIImageView})
        XCTAssertEqual(imageViews.count, 2)
        
        for index in 0..<imageViews.count {
            let imageView = imageViews[index]
            XCTAssertEqual(imageView.tag, index + 1)
            XCTAssertNil(imageView.image)
        }
    }
    
    func testSelectionViewGradientLayer() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertTrue(((segmentedView.selectionView.layer.sublayers?.contains(segmentedView.selectionViewGradientLayer)) != nil))
        XCTAssertTrue(segmentedView.selectionViewGradientLayer.isHidden)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.frame, segmentedView.selectionView.bounds)
    }
    
    func testSelectionView() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertFalse(segmentedView.selectionView.isUserInteractionEnabled)
        XCTAssertEqual(segmentedView.selectionView.backgroundColor, segmentedView.selectionViewColor)
        XCTAssertEqual(segmentedView.selectionView.layer.cornerRadius, 0.5 * segmentedView.selectionView.frame.height)
    }
    
    func testSelectionViewMask() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertEqual(segmentedView.selectionViewMask, segmentedView.selectedStateView.mask)
        XCTAssertFalse(segmentedView.selectionViewMask.isUserInteractionEnabled)
        XCTAssertEqual(segmentedView.selectionViewMask.backgroundColor, .black)
        XCTAssertEqual(segmentedView.selectionViewMask.frame, segmentedView.selectionView.frame)
        XCTAssertEqual(segmentedView.selectionViewMask.layer.cornerRadius, segmentedView.selectionView.layer.cornerRadius)
    }
    
    func testSelectedLabelsView() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertEqual(segmentedView.selectedStateView.frame, segmentedView.bounds)
        XCTAssertFalse(segmentedView.selectedStateView.isUserInteractionEnabled)
        XCTAssertTrue(segmentedView.selectedStateView.clipsToBounds)
        XCTAssertEqual(segmentedView.selectedStateView.autoresizingMask, [.flexibleWidth, .flexibleHeight])
        XCTAssertEqual(segmentedView.selectedStateView.backgroundColor, .clear)
    }
    
    func testSelectedStateLabels() {
        // Given
        let titles = segmentedView.titles
        
        // When
        segmentedView.layoutSubviews()
        
        // Then
        let labels = segmentedView.selectedStateView.subviews.compactMap({$0 as? UILabel})
        XCTAssertEqual(labels.count, 2)
        
        for index in 0..<labels.count {
            let label = labels[index]
            XCTAssertEqual(label.tag, index + 1)
            XCTAssertEqual(label.textAlignment, .center)
            XCTAssertEqual(label.attributedText, titles[index].availableSelectedAttributedText)
        }
    }
    
    func testSelectedStateImagesViews() {
        // When
        segmentedView.layoutSubviews()
        
        // Then
        let imageViews = segmentedView.selectedStateView.subviews.compactMap({$0 as? UIImageView})
        XCTAssertEqual(imageViews.count, 2)
        
        for index in 0..<imageViews.count {
            let imageView = imageViews[index]
            XCTAssertEqual(imageView.tag, index + 1)
            XCTAssertNil(imageView.image)
        }
    }
    
    
    func testSelectItemAtIndex() {
        // Given
        let initialSelectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectItem(at: 1)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
        XCTAssertNotEqual(segmentedView.selectionView.frame, initialSelectionViewFrame)
    }
    
    func testSelectItemAtIndexWhenIndexIsBiggerThanTitlesCount() {
        // Given
        let initialSelectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectItem(at: 10)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
        XCTAssertNotEqual(segmentedView.selectionView.frame, initialSelectionViewFrame)
    }
    
    func testSelectItemAtIndexWhenIndexIsNegative() {
        // Given
        let initialSelectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectItem(at: -10)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 0)
        XCTAssertEqual(segmentedView.selectionView.frame, initialSelectionViewFrame)
    }
    
    func testTitleForItemAtIndex() {
        // When
        let title = segmentedView.titleForItem(at: 1)
        
        // Then
        XCTAssertNotNil(title)
        XCTAssertEqual(title?.text, segmentedView.titles[1].text)
    }
    
    func testTitleForItemAtIndexWhenIndexIsBiggerThanTitlesCount() {
        // When
        let title = segmentedView.titleForItem(at: 10)
        
        // Then
        XCTAssertNotNil(title)
        XCTAssertEqual(title?.text, segmentedView.titles[1].text)
    }
    
    func testTitleForItemAtIndexWhenIndexIsNegative() {
        // When
        let title = segmentedView.titleForItem(at: -10)
        
        // Then
        XCTAssertNotNil(title)
        XCTAssertEqual(title?.text, segmentedView.titles[0].text)
    }
    
    func testTitleForItemAtIndexWhenNoTitles() {
        // Given
        segmentedView.titles = []
        
        // When
        let title = segmentedView.titleForItem(at: 0)
        
        // Then
        XCTAssertNil(title)
    }
}
