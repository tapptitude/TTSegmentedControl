//
//  TTSwiftUISegmentedControl.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import SwiftUI

public struct TTSwiftUISegmentedControl: UIViewRepresentable {
    @Binding private var selectedIndex: Int?
    private let titles: [TTSegmentedControlTitle]
    private var titleDistribution: TTSegmentedControl.TitleDistribution = .fillEqually
    private var selectionViewPadding: CGSize = .init(width: 2, height: 2)
    private var isDragEnabled: Bool = true
    private var animationOptions: TTSegmentedControlAnimationOption? = .init()
    private var isSizeAdjustEnabled: Bool = false
    private var containerColorType: TTSegmentedControl.ColorType = .color(value: .white)
    private var containerViewInnerShadow: TTSegmentedControlShadow? = nil
    private var selectionViewColorType: TTSegmentedControl.ColorType = .color(value: .blue)
    private var switchSecondSelectionViewColorType: TTSegmentedControl.ColorType?
    private var selectionViewShadow: TTSegmentedControlShadow? = nil
    private var selectionViewFillType: TTSegmentedControl.SelectionViewFillType = .fillSegment
    private var bounceAnimationOptions: TTSegmentedControlBounceOptions? = nil
    private var cornerRadius: TTSegmentedControl.CornerRadius = .maximum
    private var cornerCurve: CALayerCornerCurve = .continuous
    private var isSwitchBehaviorEnabled: Bool = true
    private var didBeginTouch: (() -> Void)? = nil
    private var didDragOverItemAtIndex: ((Int) -> Void)? = nil
    private var didEndTouchAtIndex: ((Int) -> Void)? = nil
    private var segmentedView: TTSegmentedControl?
    
    public init(
        titles: [TTSegmentedControlTitle],
        selectedIndex: Binding<Int?>? = .constant(nil)
    ) {
        self.titles = titles
        self._selectedIndex = selectedIndex ?? Binding.constant(nil)
    }
    
    init(
        titles: [TTSegmentedControlTitle],
        selectedIndex: Binding<Int?>? = .constant(nil),
        segmentedView: TTSegmentedControl
    ) {
        self.titles = titles
        self._selectedIndex = selectedIndex ?? Binding.constant(nil)
        self.segmentedView = segmentedView
    }
    
    public func makeUIView(context: Context) -> UIView {
        let segmentedView = segmentedView ?? TTSegmentedControl()
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
        segmentedView.padding = selectionViewPadding
        segmentedView.bounceAnimationOptions = bounceAnimationOptions
        segmentedView.selectionViewShadow = selectionViewShadow
        segmentedView.isDragEnabled = isDragEnabled
        segmentedView.animationOptions = animationOptions
        segmentedView.isSizeAdjustEnabled = isSizeAdjustEnabled
        segmentedView.containerColorType = containerColorType
        segmentedView.containerViewInnerShadow = containerViewInnerShadow
        segmentedView.selectionViewColorType = selectionViewColorType
        segmentedView.switchSecondSelectionViewColorType = switchSecondSelectionViewColorType
        segmentedView.selectionViewFillType = selectionViewFillType
        segmentedView.cornerRadius = cornerRadius
        segmentedView.cornerCurve = cornerCurve
        segmentedView.isSwitchBehaviorEnabled = isSwitchBehaviorEnabled
        segmentedView.delegate = context.coordinator
        if let selectedIndex = selectedIndex {
            segmentedView.selectItem(at: selectedIndex, animated: false)
        }
    }
}

extension TTSwiftUISegmentedControl {
    public func titleDistribution(_ distribution: TTSegmentedControl.TitleDistribution) -> TTSwiftUISegmentedControl {
        var view = self
        view.titleDistribution = distribution
        return view
    }
    
    public func selectionViewPadding(_ padding: CGSize) -> TTSwiftUISegmentedControl {
        var view = self
        view.selectionViewPadding = padding
        return view
    }
    
    public func isDragEnabled(_ value: Bool) -> TTSwiftUISegmentedControl {
        var view = self
        view.isDragEnabled = value
        return view
    }
    
    public func animationOptions(_ options: TTSegmentedControlAnimationOption?) -> TTSwiftUISegmentedControl {
        var view = self
        view.animationOptions = options
        return view
    }
    
    public func isSizeAdjustEnabled(_ value: Bool) -> TTSwiftUISegmentedControl {
        var view = self
        view.isSizeAdjustEnabled = value
        return view
    }

    public func containerColorType(_ colorType: TTSegmentedControl.ColorType) -> TTSwiftUISegmentedControl {
        var view = self
        view.containerColorType = colorType
        return view
    }
    
    public func selectionViewColorType(_ colorType: TTSegmentedControl.ColorType) -> TTSwiftUISegmentedControl {
        var view = self
        view.selectionViewColorType = colorType
        return view
    }
    
    public func switchSecondSelectionViewColorType(_ colorType: TTSegmentedControl.ColorType?) -> TTSwiftUISegmentedControl {
        var view = self
        view.switchSecondSelectionViewColorType = colorType
        return view
    }
    
    public func selectionViewShadow(_ shadow: TTSegmentedControlShadow?) -> TTSwiftUISegmentedControl {
        var view = self
        view.selectionViewShadow = shadow
        return view
    }
    
    public func selectionViewFillType(_ type: TTSegmentedControl.SelectionViewFillType) -> TTSwiftUISegmentedControl {
        var view = self
        view.selectionViewFillType = type
        return view
    }
    
    public func bounceAnimationOptions(_ options: TTSegmentedControlBounceOptions?) -> TTSwiftUISegmentedControl {
        var view = self
        view.bounceAnimationOptions = options
        return view
    }
    
    public func cornerRadius(_ type: TTSegmentedControl.CornerRadius) -> TTSwiftUISegmentedControl {
        var view = self
        view.cornerRadius = type
        return view
    }
    
    public func cornerCurve(_ cornerCurve: CALayerCornerCurve) -> TTSwiftUISegmentedControl {
        var view = self
        view.cornerCurve = cornerCurve
        return view
    }
    
    public func isSwitchBehaviorEnabled(_ value: Bool) -> TTSwiftUISegmentedControl {
        var view = self
        view.isSwitchBehaviorEnabled = value
        return view
    }
    
    public func didBeginTouch(_ body: (() -> Void)?) -> TTSwiftUISegmentedControl {
        var view = self
        view.didBeginTouch = body
        return view
    }
    
    public func didDragOverItemAtIndex(_ body: ((Int) -> Void)?) -> TTSwiftUISegmentedControl {
        var view = self
        view.didDragOverItemAtIndex = body
        return view
    }
    
    public func didEndTouchAtIndex(_ body: ((Int) -> Void)?) -> TTSwiftUISegmentedControl {
        var view = self
        view.didEndTouchAtIndex = body
        return view
    }
    
    public func containerViewInnerShadow(_ shadow: TTSegmentedControlShadow?) -> TTSwiftUISegmentedControl {
        var view = self
        view.containerViewInnerShadow = shadow
        return view
    }
}
