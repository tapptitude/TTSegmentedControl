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
    func segmentedView(_ view: TTSegmentedControl, shouldMoveAt index: Int) -> Bool
    func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int)
}

public extension TTSegmentedControlDelegate {
    func segmentedViewDidBegin(_ view: TTSegmentedControl) {}
    func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int) {}
    func segmentedView(_ view: TTSegmentedControl, shouldMoveAt index: Int) -> Bool { true }
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
    public var containerViewInnerShadow: TTSegmentedControlShadow? { didSet { reloadView() } }
    public var containerColorType: ColorType = .color(value: .white) { didSet { configure() } }
    public var selectionViewColorType: ColorType = .color(value: .blue) { didSet { configure() } }
    public var selectionViewFillType: SelectionViewFillType = .fillSegment { didSet { updateLayout() } }
    public var switchSecondSelectionViewColorType: ColorType? { didSet { configure() } }
    public var padding: CGSize = .init(width: 2, height: 2) { didSet { reloadView() } }
    public var cornerRadius: CornerRadius = .maximum { didSet { reloadView() } }
    public var cornerCurve: CALayerCornerCurve = .circular { didSet { reloadView() } }
    public var titles: [TTSegmentedControlTitle] = [] { didSet { reloadView() } }
    public var isSwitchBehaviorEnabled: Bool = false
    
    private(set) var containerViewInnerShadowLayer = CALayer()
    private(set) var defaultStateView = UIView()
    private(set) var defaultStateViewGradientLayer = CAGradientLayer()
    private(set) var selectionView = UIView()
    private(set) var selectionViewGradientLayer = CAGradientLayer()
    private(set) var selectionViewMask = UIView()
    private(set) var selectedStateView = UIView()
    
    private var isSelectionViewTouched = false
    private var isValidTouch = true
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
            cornerCurve: cornerCurve,
            isSizeAdjustEnabled: isSizeAdjustEnabled,
            titleDistribution: titleDistribution,
            selectionViewFillType: selectionViewFillType,
            animationDuration: animationOptions?.duration ?? 0,
            containerViewInnerShadow: containerViewInnerShadow
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
        touchBegin(at: point)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        endTouch(at: point)
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
    
    @objc private func panAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        let state = gestureRecognizer.state
        let point = gestureRecognizer.location(in: self)
        
        switch state {
        case .began:
            touchBegin(at: point)
        case .ended, .cancelled:
            endTouch(at: point)
        default:
            panAction(at: point)
        }
    }

    private func touchBegin(at point: CGPoint) {
        if touchState == .touch { return }
        isValidTouch = true
        touchState = .touch
        lastTouchPoint = point
        let index = switchIndexForSelected(layout.index(for: point))
        isSelectionViewTouched = index == selectedIndex
        notifyBeginTouch(for: index)
    }
    
    private func panAction(at point: CGPoint) {
        if !isDragEnabled || !isSelectionViewTouched {
            isValidTouch = PointInsideSegmentControlCheckBuilder(viewBounds: bounds, point: point).build()
            return
        }
        touchState = .drag
        prepareTouchPointOffset(for: point)
        let pointToNotJumpViewWhenDragged = CGPoint(x: point.x + touchPointOffset.x, y: touchPointOffset.x)
        let isSwipeToLeft = point.x < lastTouchPoint.x
        layout.layoutSelectionViewAndMaskView(for: pointToNotJumpViewWhenDragged, whenUserMoveFingerToLeft: isSwipeToLeft)
        lastTouchPoint = point
        notifyDragInProgress(at: point)
    }
    
    private func endTouch(at point: CGPoint) {
        isSelectionViewTouched = false
        touchState = .none
        touchPointOffset = .zero
        
        if !isValidTouch { return }
        let newIndex = switchIndexForSelected(layout.index(for: point))
        let allowToMoveToNewIndex = delegate?.segmentedView(self, shouldMoveAt: newIndex) ?? true
        if allowToMoveToNewIndex {
            selectedIndex = newIndex
            notifyEndTouch()
        }
        updateSelectionViewFrame(at: selectedIndex)
        configureSelectionView(at: selectedIndex)
    }
}

//MARK: - Public
extension TTSegmentedControl {
    public func selectItem(at index: Int, animated: Bool = false) {
        let index = max(min(index, titles.count - 1),  0)
        selectedIndex = index
        updateSelectionViewFrame(at: index)
        configureSelectionView(at: selectedIndex)
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
        prepareContainerViewInnerShadowLayer()
        prepareDefaultStateLabels()
        prepareDefaultStateImagesViews()
        prepareSelectionView()
        prepareSelectionViewGradientLayer()
        prepareSelectionViewMask()
        prepareSelectedLabelsView()
        prepareSelectedStateLabels()
        prepareSelectedStateImagesViews()
        prepareSelectedSegmentedIndex()
        preparePanGestureRecognizer()
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
    
    private func prepareContainerViewInnerShadowLayer() {
        containerViewInnerShadowLayer = CALayer()
        defaultStateView.layer.addSublayer(containerViewInnerShadowLayer)
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
    
    private func prepareSelectedSegmentedIndex() {
        selectedIndex = min(selectedIndex, max(0, titles.count - 1))
    }
    
    private func preparePanGestureRecognizer() {
        if gestureRecognizers?.compactMap({$0 as? TestablePanGestureRecognizer}).first != nil { return }
        let panGestureRecognizer = TestablePanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
}

//MARK: - Configure subviews
extension TTSegmentedControl {
    private func configure() {
        configureContainerView()
        configureContainerGradientLayer()
        configureContainerViewInnerShadowLayer()
        configureDefaultStateLabels()
        configureDefaultStateImageViews()
        configureSelectionViewGradientLayer()
        configureSelectionView()
        configureSelectionView(at: selectedIndex)
        configureSelectedStateLabels()
        configureSelectedStateImageViews()
    }
    
    private func configureContainerView() {
        defaultStateView.backgroundColor = containerColorType.color
    }
    
    private func configureContainerGradientLayer() {
        defaultStateViewGradientLayer.isHidden = containerColorType.gradient == nil
        defaultStateViewGradientLayer.backgroundColor = UIColor.clear.cgColor
        if let containerGradient = containerColorType.gradient {
            defaultStateViewGradientLayer.apply(containerGradient)
        }
    }
    
    private func configureContainerViewInnerShadowLayer() {
        guard let containerInnerShadow = containerViewInnerShadow else { return }
        containerViewInnerShadowLayer.shadowColor = containerInnerShadow.color.cgColor
        containerViewInnerShadowLayer.shadowOffset = containerInnerShadow.offset
        containerViewInnerShadowLayer.shadowOpacity = containerInnerShadow.opacity
        containerViewInnerShadowLayer.shadowRadius = containerInnerShadow.radius
        containerViewInnerShadowLayer.masksToBounds = true
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
            imageView.image = titles[index].defaultImage
        }
    }
    
    private func configureSelectionViewGradientLayer() {
        selectionViewGradientLayer.isHidden = selectionViewColorType.gradient == nil
        selectionViewGradientLayer.backgroundColor = UIColor.black.cgColor
        if let selectionViewGradient = selectionViewColorType.gradient {
            selectionViewGradientLayer.apply(selectionViewGradient)
        }
    }
    
    private func configureSelectionView() {
        selectionView.backgroundColor = selectionViewColorType.color
        if let shadow = selectionViewShadow {
            selectionView.apply(shadow)
        }
    }
    
    private func configureSwitchSecondSelectionViewGradientLayer() {
        let gradient = switchSecondSelectionViewColorType?.gradient ?? selectionViewColorType.gradient
        selectionViewGradientLayer.isHidden = gradient == nil
        selectionViewGradientLayer.backgroundColor = UIColor.black.cgColor
        if let gradient = gradient {
            selectionViewGradientLayer.apply(gradient)
        }
    }
    
    private func configureSwitchSecondSelectionView() {
        selectionView.backgroundColor = switchSecondSelectionViewColorType?.color ?? selectionViewColorType.color
    }
    
    private func configureSelectionView(at index: Int) {
        if !isSwitch { return }
        if index == 0 {
            configureSelectionViewGradientLayer()
            configureSelectionView()
        } else {
            configureSwitchSecondSelectionViewGradientLayer()
            configureSwitchSecondSelectionView()
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
            imageView.image = titles[index].selectedImage
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
    
    public enum SelectionViewFillType {
        case fillSegment
        case fillText
    }
    
    public enum CornerRadius {
        case none
        case maximum
        case constant(value: CGFloat)
    }
    
    public enum ColorType {
        case color(value: UIColor)
        case gradient(value: TTSegmentedControlGradient)
        case colorWithGradient(color: UIColor, gradient: TTSegmentedControlGradient)
    }
}

extension TTSegmentedControl.ColorType {
    var color: UIColor? {
        switch self {
        case .color(let value):
            return value
        case .colorWithGradient(let color, _):
            return color
        default:
            return nil
        }
    }
    
    var gradient: TTSegmentedControlGradient? {
        switch self {
        case .gradient(let value):
            return value
        case .colorWithGradient(_, let gradient):
            return gradient
        default:
            return nil
        }
    }
}
