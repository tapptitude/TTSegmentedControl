//
//  TTSegmentedControlTests.swift
//  TTSegmentedControlTests
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
    
    func testUpdateLayoutWithoutAnimation() {
        // Given
        segmentedView.titles = ["Men", "3", "Women"].map({TTSegmentedControlTitle(defaultAttributedText: NSAttributedString(string: $0), selectedAttributedText: NSAttributedString(string: $0))})
        segmentedView.animationOptions = nil
        segmentedView.selectItem(at: 1)
        let selectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectionViewFillType = .fillText
        
        // Then
        XCTAssertTrue(segmentedView.selectionView.frame.width < selectionViewFrame.width)
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
        segmentedView.selectItem(at: 1)
        
        // When
        segmentedView.touchesBegan(Set([touch]), with: nil)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesBeganWithEventWhenTouchStateIsTouch() {
        // Given
        let touch = TouchFake()
        segmentedView.touchesBegan(Set([touch]), with: nil)
        delegate.reset()
        
        // When
        segmentedView.touchesBegan(Set([touch]), with: nil)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewDidBeginCalled)
    }
    
    func testTouchesEndedWithEvent() {
        // Given
        let startTouch = TouchFake()
        let endTouch = TouchFake(touchLocation: CGPoint(x: 1000, y: 5))
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
    
    func testTouchesEndedWithEventForSwitches() {
        // Given
        let selectionViewFrame = segmentedView.selectionView.frame
        
        let endTouch = TouchFake(touchLocation: CGPoint(x: 1000, y: 5))
        segmentedView.touchesEnded(Set([endTouch]), with: nil)

        // When
        segmentedView.touchesEnded(Set([endTouch]), with: nil)
        
        // Then
        XCTAssertNotEqual(segmentedView.selectedIndex, 0)
        XCTAssertNotEqual(segmentedView.selectionView.frame, selectionViewFrame)
        XCTAssertTrue(delegate.segmentedViewDidEndAtIndexCalled)
    }
    
    func testPanActionBeginAtPoint() {
        // Given
        segmentedView.layoutSubviews()
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 58, y: 5)
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewDidBeginCalled)
    }
    
    func testPanActionBeginAtPointWhenTouchStateIsTouch() {
        // Given
        segmentedView.layoutSubviews()
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 58, y: 5)
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        delegate.reset()
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewDidBeginCalled)
    }
    
    func testPanActionChangedAtPoint() {
        // Given
        segmentedView.titles = ["Men", "3", "Women"].map({TTSegmentedControlTitle(text: $0)})
        segmentedView.layoutSubviews()
        let selectionViewInitialFrame = segmentedView.selectionView.frame
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 1, y: 5)
        let changeLocation1 = CGPoint(x: 58, y: 5)
        let changeLocation2 = CGPoint(x: 60, y: 5)
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        panGestureRecognizer?.perfomTouch(location: changeLocation1, state: .changed)
        panGestureRecognizer?.perfomTouch(location: changeLocation2, state: .changed)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewdidDragAtIndexCalled)
        XCTAssertNotEqual(selectionViewInitialFrame, segmentedView.selectionView.frame)
    }
    
    func testPanActionChangetAtPointWhenIsDragEnabledFalse() {
        // Given
        segmentedView.titles = ["Men", "3", "Women"].map({TTSegmentedControlTitle(text: $0)})
        segmentedView.layoutSubviews()
        segmentedView.isDragEnabled = false
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 1, y: 5)
        let changeLocation = CGPoint(x: 58, y: 5)
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        panGestureRecognizer?.perfomTouch(location: changeLocation, state: .changed)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewdidDragAtIndexCalled)
    }
    
    func testPanActionEndedAtPoint() {
        // Given
        segmentedView.titles = ["Men", "3", "Women"].map({TTSegmentedControlTitle(text: $0)})
        segmentedView.layoutSubviews()
        let selectionViewInitialFrame = segmentedView.selectionView.frame
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 1, y: 5)
        let changeLocation1 = CGPoint(x: 58, y: 5)
        let changeLocation2 = CGPoint(x: 60, y: 5)
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        panGestureRecognizer?.perfomTouch(location: changeLocation1, state: .changed)
        panGestureRecognizer?.perfomTouch(location: changeLocation2, state: .changed)
        panGestureRecognizer?.perfomTouch(location: changeLocation2, state: .ended)
        
        // Then
        XCTAssertTrue(delegate.segmentedViewDidEndAtIndexCalled)
        XCTAssertNotEqual(selectionViewInitialFrame, segmentedView.selectionView.frame)
    }
    
    func testPanActionEndedAtPointWhenNoValidTouch() {
        // Given
        segmentedView.titles = ["Men", "3", "Women"].map({TTSegmentedControlTitle(text: $0)})
        segmentedView.layoutSubviews()
        segmentedView.isDragEnabled = false
        let selectionViewInitialFrame = segmentedView.selectionView.frame
        let panGestureRecognizer = segmentedView.gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first
        let startLocation = CGPoint(x: 1, y: 5)
        let changeLocation1 = CGPoint(x: -158, y: 5)
        let changeLocation2 = CGPoint(x: 60, y: 5)
        
        // When
        panGestureRecognizer?.perfomTouch(location: startLocation, state: .began)
        panGestureRecognizer?.perfomTouch(location: changeLocation1, state: .changed)
        panGestureRecognizer?.perfomTouch(location: changeLocation2, state: .ended)
        
        // Then
        XCTAssertFalse(delegate.segmentedViewDidEndAtIndexCalled)
        XCTAssertEqual(selectionViewInitialFrame, segmentedView.selectionView.frame)
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
        segmentedView.layoutSubviews()
        
        // When
        segmentedView.selectionViewColorType = .gradient(value: gradient)
        
        // Then
        XCTAssertTrue(((segmentedView.selectionView.layer.sublayers?.contains(segmentedView.selectionViewGradientLayer)) != nil))
        XCTAssertFalse(segmentedView.selectionViewGradientLayer.isHidden)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.frame, segmentedView.selectionView.bounds)
        XCTAssertNil(segmentedView.selectionViewGradientLayer.locations)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.startPoint, gradient.startPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.endPoint, gradient.endPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.first as! CGColor, gradient.colors.first?.cgColor)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.last as! CGColor, gradient.colors.last?.cgColor)
    }
    
    func testSelectionView() {
        // Given
        segmentedView.selectionViewColorType = .color(value: .red)
        
        // When
        segmentedView.layoutSubviews()
        
        // Then
        XCTAssertFalse(segmentedView.selectionView.isUserInteractionEnabled)
        XCTAssertEqual(segmentedView.selectionView.backgroundColor, .red)
        XCTAssertEqual(segmentedView.selectionView.layer.cornerRadius, 0.5 * segmentedView.selectionView.frame.height)
    }

    func testSwitchSecondSelectionViewGradientLayer() {
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
        segmentedView.layoutSubviews()
        segmentedView.isSwitchBehaviorEnabled = true
        segmentedView.switchSecondSelectionViewColorType = .gradient(value: gradient)
        
        // When
        segmentedView.selectItem(at: 1)
        
        // Then
        XCTAssertTrue(((segmentedView.selectionView.layer.sublayers?.contains(segmentedView.selectionViewGradientLayer)) != nil))
        XCTAssertFalse(segmentedView.selectionViewGradientLayer.isHidden)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.frame, segmentedView.selectionView.bounds)
        XCTAssertNil(segmentedView.selectionViewGradientLayer.locations)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.startPoint, gradient.startPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.endPoint, gradient.endPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.first as! CGColor, gradient.colors.first?.cgColor)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.last as! CGColor, gradient.colors.last?.cgColor)
    }
    
    func testSwitchSecondSelectionView() {
        // given
        segmentedView.layoutSubviews()
        segmentedView.switchSecondSelectionViewColorType = .color(value: .blue)
        segmentedView.isSwitchBehaviorEnabled = true
        
        // When
        segmentedView.selectItem(at: 1)
        
        // Then
        XCTAssertFalse(segmentedView.selectionView.isUserInteractionEnabled)
        XCTAssertEqual(segmentedView.selectionView.backgroundColor, .blue)
        XCTAssertEqual(segmentedView.selectionView.layer.cornerRadius, 0.5 * segmentedView.selectionView.frame.height)
    }
    
    func testSelectionViewWithColorAndGradient() {
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
        segmentedView.layoutSubviews()
        
        // When
        segmentedView.selectionViewColorType = .colorWithGradient(color: .red, gradient: gradient)
        
        // Then
        XCTAssertTrue(((segmentedView.selectionView.layer.sublayers?.contains(segmentedView.selectionViewGradientLayer)) != nil))
        XCTAssertFalse(segmentedView.selectionViewGradientLayer.isHidden)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.frame, segmentedView.selectionView.bounds)
        XCTAssertEqual(segmentedView.selectionView.backgroundColor, .red)
        XCTAssertNil(segmentedView.selectionViewGradientLayer.locations)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.startPoint, gradient.startPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.endPoint, gradient.endPoint)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.first as! CGColor, gradient.colors.first?.cgColor)
        XCTAssertEqual(segmentedView.selectionViewGradientLayer.colors?.last as! CGColor, gradient.colors.last?.cgColor)
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
    
    func testSelectItemAtIndexWithoutAnimation() {
        // Given
        segmentedView.animationOptions = nil
        let initialSelectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectItem(at: 1)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
        XCTAssertNotEqual(segmentedView.selectionView.frame, initialSelectionViewFrame)
    }
    
    func testSelectItemAtIndexWithBounceAnimation() {
        // Given
        segmentedView.bounceAnimationOptions = TTSegmentedControlBounceOptions()
        let initialSelectionViewFrame = segmentedView.selectionView.frame
        
        // When
        segmentedView.selectItem(at: 1)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
        XCTAssertNotEqual(segmentedView.selectionView.frame, initialSelectionViewFrame)
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
    
    func testSwitchIndexWhenTouchOnTheSamePosition() {
        // Given
        let touch = TouchFake()
        segmentedView.isSwitchBehaviorEnabled = true
        segmentedView.touchesBegan(Set([touch]), with: nil)
        
        // When
        segmentedView.touchesEnded(Set([touch]), with: nil)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
    }
    
    func testSwitchIndexWhenTouchOnTheDifferentPosition() {
        // Given
        segmentedView.layoutSubviews()
        let touch = TouchFake(touchLocation: CGPoint(x: segmentedView.frame.width - 1, y: 0))
        segmentedView.isSwitchBehaviorEnabled = true
        segmentedView.touchesBegan(Set([touch]), with: nil)
        
        // When
        segmentedView.touchesEnded(Set([touch]), with: nil)
        
        // Then
        XCTAssertEqual(segmentedView.selectedIndex, 1)
    }
}
