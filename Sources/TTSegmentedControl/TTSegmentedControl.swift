//
//  TTSegmentedControl.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 26.01.2023.
//

import UIKit

public protocol TTSegmentedControlDelegate: AnyObject {
    func segmentedViewDidBegin(_ view: TTSegmentedControl)
    func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int)
    func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int)
}

extension TTSegmentedControlDelegate {
    func segmentedViewDidBegin(_ view: TTSegmentedControl) {}
    func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int) {}
    func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int) {}
}

public final class TTSegmentedControl: UIView {
    public weak var delegate: TTSegmentedControlDelegate?
    public private(set) var selectedIndex: Int = 0
    public var bounceAnimationOptions: TTSegmentedControlBounceOptions?
    public var selectionViewShadow: TTSegmentedControlShadow? { didSet { configure() } }
    public var titleDistribution: TitleDistribution = .equalSpacing { didSet { reloadView() } }
    public var isDragEnabled: Bool = true
    public var animationOptions: TTSegmentedControlAnimationOption? = .init()
    public var isSizeAdjustEnabled: Bool = true
    public var containerBackgroundColor: UIColor = .white { didSet { configure() } }
    public var containerGradient: TTSegmentedControlGradient? { didSet { configure() } }
    public var selectionViewColor: UIColor = .blue { didSet { configure() } }
    public var selectionViewGradient: TTSegmentedControlGradient? { didSet { configure() } }
    public var padding: CGSize = .init(width: 2, height: 2) { didSet { reloadView() } }
    public var cornerRadius: CGFloat = -1 { didSet { reloadView() } }
    public var titles: [TTSegmentedControlTitle] = [] { didSet { reloadView() } }
    public var isSwitchBehaviorEnabled: Bool = true
    
    private(set) var defaultStateView = UIView()
    private(set) var defaultStateViewGradientLayer = CAGradientLayer()
    private(set) var selectionView = UIView()
    private(set) var selectionViewGradientLayer = CAGradientLayer()
    private(set) var selectionViewMask = UIView()
    private(set) var selectedStateView = UIView()
    
    private var isLayoutUpdated = false
    private var isSwitch: Bool { titles.count == 2 && isSwitchBehaviorEnabled }
    private var lastTouchPoint: CGPoint = .zero
    private var touchPointOffset: CGPoint = .zero
    private var touchState: TouchState = .none
    private lazy var layout: TTSegmentedControlLayout = { .init(view: self) }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayoutUpdated {
            isLayoutUpdated = true
            prepare()
            configure()
        }
        
        if touchState == .none {
            updateLayout()
        }
    }
    
    private func updateLayout() {
        let layoutParams = LayoutParameter(
            defaultTitlesSizes: titles.map({$0.availableDefaultAttributedText.textSize}),
            selectedTitlesSizes: titles.map({$0.availableSelectedAttributedText.textSize}),
            spaceBetweenTitleItems: titles.map({$0.spaceBetweenTextAndImage}),
            imagesSizes: titles.map({$0.availableImageSize}),
            imagePositions: titles.map({$0.imagePosition}),
            selectedIndex: selectedIndex,
            padding: padding,
            cornerRadius: cornerRadius,
            isSizeAdjustEnabled: isSizeAdjustEnabled,
            titleDistribution: titleDistribution,
            animationDuration: animationOptions?.duration ?? 0
        )
        layout.layoutSubviews(with: layoutParams)
    }
    
    private func reloadView() {
        prepare()
        configure()
        updateLayout()
    }
}

//MARK: - Touches
extension TTSegmentedControl {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        touchState = .touch
        lastTouchPoint = point
        let index = switchIndexForSelected(layout.index(for: point))
        updateSelectionViewFrame(at: index)
        notifyBeginTouch(for: index)
        selectedIndex = index
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragEnabled { return }
        guard let point = touches.first?.location(in: self) else { return }
        touchState = .drag
        prepareTouchPointOffset(for: point)
        let pointToNotJumpViewWhenDragged = CGPoint(x: point.x + touchPointOffset.x, y: touchPointOffset.x)
        let isSwipeToLeft = point.x < lastTouchPoint.x
        layout.layoutSelectionViewAndMaskView(for: pointToNotJumpViewWhenDragged, whenUserMoveFingerToLeft: isSwipeToLeft)
        lastTouchPoint = point
        notifyDragInProgress(at: point)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self), touchState == .drag {
            selectedIndex = layout.index(for: point)
            updateSelectionViewFrame(at: selectedIndex)
        }
        touchState = .none
        touchPointOffset = .zero
        notifyEndTouch()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    private func prepareTouchPointOffset(for point: CGPoint) {
        if !touchPointOffset.equalTo(.zero) { return }
        touchPointOffset = CGPoint(x: selectionView.center.x - point.x, y: selectionView.center.x)
    }
    
    private func updateSelectionViewFrame(at index: Int) {
        guard let animationOptions = animationOptions else {
            layout.layoutSelectionViewAndMaskView(at: index)
            return
        }
        if let bounceAnimationOptions = bounceAnimationOptions {
            UIView.animate(with: animationOptions, using: bounceAnimationOptions) {
                self.layout.layoutSelectionViewAndMaskView(at: index)
            }
        } else {
            UIView.animate(with: animationOptions) {
                self.layout.layoutSelectionViewAndMaskView(at: index)
            }
        }
    }
    
    private func switchIndexForSelected(_ index: Int) -> Int {
        if !isSwitch { return index }
        if index == selectedIndex {
            return index == 0 ? 1 : 0
        } else {
            return index
        }
    }
}

//MARK: - Public
extension TTSegmentedControl {
    public func selectItem(at index: Int, animated: Bool = false) {
        let index = max(min(index, titles.count - 1),  0)
        selectedIndex = index
        updateSelectionViewFrame(at: index)
    }
    
    public func titleForItem(at index: Int) -> TTSegmentedControlTitle? {
        if titles.count == 0 { return nil }
        let index = max(min(index, titles.count - 1),  0)
        return titles[index]
    }
}

//MARK: - Prepare
extension TTSegmentedControl {
    private func prepare() {
        removeAllSubviews()
        prepareView()
        prepareContainerView()
        prepareContainerGradientLayer()
        prepareDefaultStateLabels()
        prepareDefaultStateImagesViews()
        prepareSelectionView()
        prepareSelectionViewGradientLayer()
        prepareSelectionViewMask()
        prepareSelectedLabelsView()
        prepareSelectedStateLabels()
        prepareSelectedStateImagesViews()
    }

    private func removeAllSubviews() {
        subviews.forEach({$0.removeFromSuperview()})
    }
    
    private func prepareView() {
        backgroundColor = .clear
    }
    
    private func prepareContainerView() {
        defaultStateView = UIView()
        prepareLabelsHolder(defaultStateView)
    }
    
    private func prepareContainerGradientLayer() {
        defaultStateViewGradientLayer = CAGradientLayer()
        defaultStateView.layer.addSublayer(defaultStateViewGradientLayer)
    }
    
    private func prepareDefaultStateLabels() {
        for index in 0..<titles.count {
            let label = UILabel()
            label.attributedText = titles[index].availableDefaultAttributedText
            label.tag = index + 1
            label.textAlignment = .center
            defaultStateView.addSubview(label)
        }
    }
    
    private func prepareDefaultStateImagesViews() {
        for index in 0..<titles.count {
            let imageView = UIImageView()
            imageView.tag = index + 1
            defaultStateView.addSubview(imageView)
        }
    }
    
    private func prepareSelectionViewGradientLayer() {
        selectionViewGradientLayer = CAGradientLayer()
        selectionView.layer.addSublayer(selectionViewGradientLayer)
    }
    
    private func prepareSelectionView() {
        selectionView = UIView()
        selectionView.isUserInteractionEnabled = false
        addSubview(selectionView)
    }
    
    private func prepareSelectionViewMask() {
        selectionViewMask = UIView()
        selectionViewMask.isUserInteractionEnabled = false
        selectionViewMask.backgroundColor = .black
    }
    
    private func prepareSelectedLabelsView() {
        selectedStateView = UIView()
        selectedStateView.mask = selectionViewMask
        selectedStateView.backgroundColor = .clear
        prepareLabelsHolder(selectedStateView)
    }
    
    private func prepareSelectedStateLabels() {
        for index in 0..<titles.count {
            let label = UILabel()
            label.isUserInteractionEnabled = false
            label.attributedText = titles[index].availableSelectedAttributedText
            label.tag = index + 1
            label.textAlignment = .center
            selectedStateView.addSubview(label)
        }
    }
    
    private func prepareSelectedStateImagesViews() {
        for index in 0..<titles.count {
            let imageView = UIImageView()
            imageView.tag = index + 1
            imageView.isUserInteractionEnabled = false
            selectedStateView.addSubview(imageView)
        }
    }
    
    private func prepareLabelsHolder(_ view: UIView) {
        view.frame = bounds
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

//MARK: - Configure subviews
extension TTSegmentedControl {
    private func configure() {
        configureContainerView()
        configureContainerGradientLayer()
        configureDefaultStateLabels()
        configureDefaultStateImageViews()
        configureSelectionViewGradientLayer()
        configureSelectionView()
        configureSelectedStateLabels()
        configureSelectedStateImageViews()
    }
    
    private func configureContainerView() {
        defaultStateView.backgroundColor = containerGradient == nil ? containerBackgroundColor : nil
    }
    
    private func configureContainerGradientLayer() {
        defaultStateViewGradientLayer.isHidden = containerGradient == nil
        defaultStateViewGradientLayer.backgroundColor = UIColor.clear.cgColor
        if let containerGradient = containerGradient {
            defaultStateViewGradientLayer.apply(containerGradient)
        }
    }
    
    private func configureDefaultStateLabels() {
        for index in 0..<titles.count {
            let tag = index + 1
            guard let label = defaultStateView.subviews.compactMap({$0 as? UILabel}).first(where: {$0.tag == tag}) else { continue }
            label.attributedText = titles[index].availableDefaultAttributedText
        }
    }
    
    private func configureDefaultStateImageViews() {
        for index in 0..<titles.count {
            let tag = index + 1
            guard let imageView = defaultStateView.subviews.compactMap({$0 as? UIImageView}).first(where: {$0.tag == tag}) else { continue }
            let imageName = titles[index].defaultImageName ?? ""
            imageView.image = imageName.isEmpty ? nil : UIImage(named: imageName)
        }
    }
    
    private func configureSelectionViewGradientLayer() {
        selectionViewGradientLayer.isHidden = selectionViewGradient == nil
        selectionViewGradientLayer.backgroundColor = UIColor.black.cgColor
        if let selectionViewGradient = selectionViewGradient {
            selectionViewGradientLayer.apply(selectionViewGradient)
        }
    }
    
    private func configureSelectionView() {
        selectionView.backgroundColor = selectionViewGradient == nil ? selectionViewColor : nil
        if let shadow = selectionViewShadow {
            selectionView.apply(shadow)
        }
    }
    
    private func configureSelectedStateLabels() {
        for index in 0..<titles.count {
            let tag = index + 1
            guard let label = selectedStateView.subviews.compactMap({$0 as? UILabel}).first(where: {$0.tag == tag}) else { continue }
            label.attributedText = titles[index].availableSelectedAttributedText
        }
    }
    
    private func configureSelectedStateImageViews() {
        for index in 0..<titles.count {
            let tag = index + 1
            guard let imageView = selectedStateView.subviews.compactMap({$0 as? UIImageView}).first(where: {$0.tag == tag}) else { continue }
            let imageName = titles[index].selectedImageName ?? ""
            imageView.image = imageName.isEmpty ? nil : UIImage(named: imageName)
        }
    }
}

//MARK: - Notify
extension TTSegmentedControl {
    private func notifyBeginTouch(for index: Int) {
        if index == selectedIndex { return }
        delegate?.segmentedViewDidBegin(self)
    }
    
    private func notifyDragInProgress(at point: CGPoint) {
        guard let delegate = delegate else { return }
        let index = layout.index(for: point)
        delegate.segmentedView(self, didDragAt: index)
    }
    
    private func notifyEndTouch() {
        delegate?.segmentedView(self, didEndAt: selectedIndex)
    }
}

extension TTSegmentedControl {
    private enum TouchState {
        case none
        case drag
        case touch
    }
    
    public enum TitleDistribution {
        case fillEqually
        case equalSpacing
    }
}