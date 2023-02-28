//
//  TTSwiftUISegmentedControl.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import SwiftUI

public struct TTSwiftUISegmentedControl: UIViewRepresentable {
    @Binding private var selectedIndex: Int?
    private let bounceAnimationOptions: TTSegmentedControlBounceOptions?
    private let selectionViewShadow: TTSegmentedControlShadow?
    private let titleDistribution: TTSegmentedControl.TitleDistribution
    private let isDragEnabled: Bool
    private let animationOptions: TTSegmentedControlAnimationOption?
    private let isSizeAdjustEnabled: Bool
    private let containerBackgroundColor: UIColor
    private let containerGradient: TTSegmentedControlGradient?
    private let selectionViewColor: UIColor
    private let selectionViewGradient: TTSegmentedControlGradient?
    private let padding: CGSize
    private let cornerRadius: CGFloat
    private let titles: [TTSegmentedControlTitle]
    private let isSwitchBehaviorEnabled: Bool
    private let didBeginTouch: (() -> Void)?
    private let didDragOverItemAtIndex: ((Int) -> Void)?
    private let didEndTouchAtIndex: ((Int) -> Void)?
    
    public init(
        titles: [TTSegmentedControlTitle] = [],
        titleDistribution: TTSegmentedControl.TitleDistribution = .equalSpacing,
        selectedIndex: Binding<Int?>? = .constant(nil),
        padding: CGSize = .init(width: 2, height: 2),
        isDragEnabled: Bool = true,
        animationOptions: TTSegmentedControlAnimationOption? = .init(),
        isSizeAdjustEnabled: Bool = false,
        containerBackgroundColor: UIColor = .white,
        containerGradient: TTSegmentedControlGradient? = nil,
        selectionViewColor: UIColor = .blue,
        selectionViewGradient: TTSegmentedControlGradient? = nil,
        selectionViewShadow: TTSegmentedControlShadow? = nil,
        bounceAnimationOptions: TTSegmentedControlBounceOptions? = nil,
        cornerRadius: CGFloat = -1,
        isSwitchBehaviorEnabled: Bool = true,
        didBeginTouch: (() -> Void)? = nil,
        didDragOverItemAtIndex: ((Int) -> Void)? = nil,
        didEndTouchAtIndex: ((Int) -> Void)? = nil
    ) {
        self.titles = titles
        self.titleDistribution = titleDistribution
        self._selectedIndex = selectedIndex ?? Binding.constant(nil)
        self.padding = padding
        self.bounceAnimationOptions = bounceAnimationOptions
        self.selectionViewShadow = selectionViewShadow
        self.isDragEnabled = isDragEnabled
        self.animationOptions = animationOptions
        self.isSizeAdjustEnabled = isSizeAdjustEnabled
        self.containerBackgroundColor = containerBackgroundColor
        self.containerGradient = containerGradient
        self.selectionViewColor = selectionViewColor
        self.selectionViewGradient = selectionViewGradient
        self.cornerRadius = cornerRadius
        self.isSwitchBehaviorEnabled = isSwitchBehaviorEnabled
        self.didBeginTouch = didBeginTouch
        self.didDragOverItemAtIndex = didDragOverItemAtIndex
        self.didEndTouchAtIndex = didEndTouchAtIndex
    }
    
    public func makeUIView(context: Context) -> UIView {
        let segmentedView = TTSegmentedControl()
        update(segmentedView, in: context)
        return segmentedView
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        if let segmentedView = view as? TTSegmentedControl {
            update(segmentedView, in: context)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            selectedIndex: $selectedIndex,
            didBeginTouch: didBeginTouch,
            didDragOverItemAtIndex: didDragOverItemAtIndex,
            didEndTouchAtIndex: didEndTouchAtIndex
        )
    }
    
    final public class Coordinator: TTSegmentedControlDelegate {
        @Binding private var selectedIndex: Int?
        private let didBeginTouch: (() -> Void)?
        private let didDragOverItemAtIndex: ((Int) -> Void)?
        private let didEndTouchAtIndex: ((Int) -> Void)?
        
        init(
            selectedIndex: Binding<Int?>?,
            didBeginTouch: (() -> Void)?,
            didDragOverItemAtIndex: ((Int) -> Void)?,
            didEndTouchAtIndex: ((Int) -> Void)?
        ) {
            self._selectedIndex = selectedIndex ?? Binding.constant(nil)
            self.didBeginTouch = didBeginTouch
            self.didDragOverItemAtIndex = didDragOverItemAtIndex
            self.didEndTouchAtIndex = didEndTouchAtIndex
        }
        
        public func segmentedViewDidBegin(_ view: TTSegmentedControl) {
            didBeginTouch?()
        }
        
        public func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int) {
            didDragOverItemAtIndex?(index)
        }
        
        public func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int) {
            selectedIndex = index
            didEndTouchAtIndex?(index)
        }
    }
}

extension TTSwiftUISegmentedControl {
    private func update(_ segmentedView: TTSegmentedControl, in context: Context) {
        segmentedView.titles = titles
        segmentedView.titleDistribution = titleDistribution
        segmentedView.padding = padding
        segmentedView.bounceAnimationOptions = bounceAnimationOptions
        segmentedView.selectionViewShadow = selectionViewShadow
        segmentedView.isDragEnabled = isDragEnabled
        segmentedView.animationOptions = animationOptions
        segmentedView.isSizeAdjustEnabled = isSizeAdjustEnabled
        segmentedView.containerBackgroundColor = containerBackgroundColor
        segmentedView.containerGradient = containerGradient
        segmentedView.selectionViewColor = selectionViewColor
        segmentedView.selectionViewGradient = selectionViewGradient
        segmentedView.cornerRadius = cornerRadius
        segmentedView.isSwitchBehaviorEnabled = isSwitchBehaviorEnabled
        segmentedView.delegate = context.coordinator
        if let selectedIndex = selectedIndex {
            segmentedView.selectItem(at: selectedIndex, animated: false)
        }
    }
}
