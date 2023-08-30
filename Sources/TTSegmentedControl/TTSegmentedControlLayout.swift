//
//  TTSegmentedControlLayout.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

final class TTSegmentedControlLayout {
    private weak var view: TTSegmentedControl!
    private var params: LayoutParameter!
    private var defaultTitleComponentsFrames = [TitleComponentFrame]()
    private var selectedTitleComponentsFrames = [TitleComponentFrame]()
    private var selectionViewFrames = [CGRect]()
    
    init(view: TTSegmentedControl!) {
        self.view = view
    }
}

extension TTSegmentedControlLayout {
    func layoutSubviews(with params: LayoutParameter) {
        self.params = params
        adjustSizeIfNeeded()
        layoutDefaultStateView()
        layoutContainerGradientLayer()
        layoutContainerViewInnerShadowLayer()
        prepareTitleComponentsFrames()
        prepareSelectionViewFrames()
        layoutDefaultStateLabels()
        layoutDefaultStateImageViews()
        layoutSelectedtStateLabels()
        layoutSelectedStateImageViews()
        layoutSelectionView(for: params.selectedIndex)
        layoutSelectionViewMask()
        layoutSelectionViewGradientLayer()
        layoutSelectionViewInnerShadowLayer()
    }
    
    func layoutSelectionViewAndMaskView(for point: CGPoint) {
        layoutSelectionView(for: point)
        layoutSelectionViewMask()
        layoutSelectionViewGradientLayer(animated: true)
        layoutSelectionViewInnerShadowLayer(animated: true)
    }
    
    func layoutSelectionViewAndMaskView(at index: Int) {
        layoutSelectionView(for: index)
        layoutSelectionViewMask()
        layoutSelectionViewGradientLayer(animated: true)
        layoutSelectionViewInnerShadowLayer(animated: true)
    }
    
    func layoutSelectionViewAndMaskView(for point: CGPoint, whenUserMoveFingerToLeft isMovingToLeft: Bool) {
        let builder = SelectionViewFrameForPointBuilder(
            viewBounds: view.bounds,
            point: point,
            isMovingToLeft: isMovingToLeft,
            selectedTitleComponentsFrames: selectedTitleComponentsFrames,
            selectionViewFrames: selectionViewFrames
        )
        guard let frame = builder.build() else {
            layoutSelectionView(for: point)
            layoutSelectionViewMask()
            layoutSelectionViewGradientLayer()
            layoutSelectionViewInnerShadowLayer()
            return
        }
        layoutSelectionView(with: frame)
        layoutSelectionViewMask()
        layoutSelectionViewGradientLayer()
        layoutSelectionViewInnerShadowLayer()
    }
}

extension TTSegmentedControlLayout {
    private func prepareTitleComponentsFrames() {
        var builder = TitleComponentFrameListBuilder(
            viewBounds: view.bounds,
            cornerRadius: params.cornerRadius,
            textsSizes: params.defaultTextsSizes,
            imagesSizes: params.imagesSizes,
            spaceBetweenTitleItems: params.spaceBetweenTitleItems,
            imagePositions: params.imagePositions,
            padding: params.padding,
            titleDistribution: params.titleDistribution
        )
        
        defaultTitleComponentsFrames = builder.build()
        
        builder = TitleComponentFrameListBuilder(
            viewBounds: view.bounds,
            cornerRadius: params.cornerRadius,
            textsSizes: params.selectedTextsSizes,
            imagesSizes: params.imagesSizes,
            spaceBetweenTitleItems: params.spaceBetweenTitleItems,
            imagePositions: params.imagePositions,
            padding: params.padding,
            titleDistribution: params.titleDistribution
        )
        
        selectedTitleComponentsFrames = builder.build()
    }
    
    private func prepareSelectionViewFrames() {
        var frames = [CGRect]()
        for index in 0..<params.selectedTextsSizes.count {
            let frameBuilder = SelectionViewFrameForIndexBuilder(
                viewBounds: view.bounds,
                defaultTitleComponentsFrames: defaultTitleComponentsFrames,
                selectedTitleComponentsFrames: selectedTitleComponentsFrames,
                index: index,
                padding: params.padding,
                selectionViewFillType: params.selectionViewFillType
            )
            let frame = frameBuilder.build()
            frames.append(frame)
        }
        selectionViewFrames = frames
    }
}

extension TTSegmentedControlLayout {
    private func layoutDefaultStateView() {
        view.defaultStateView.layer.cornerCurve = params.cornerCurve
        view.defaultStateView.layer.cornerRadius = CornerRadiusBuilder(frame: view.bounds, cornerRadius: params.cornerRadius).build()
    }
    
    private func adjustSizeIfNeeded() {
        if !params.isSizeAdjustEnabled { return }
        
        let builder = MinSizeBuilder(
            defaultTextsSizes: params.defaultTextsSizes,
            selectedTextsSizes: params.selectedTextsSizes,
            imagesSizes: params.imagesSizes,
            spaceBetweenTitleItems: params.spaceBetweenTitleItems,
            imagePositions: params.imagePositions,
            currentBounds: view.bounds.size,
            cornerRadius: params.cornerRadius,
            padding: params.padding,
            titleDistribution: params.titleDistribution
        )
        let defaultSize = builder.build()
        let width = max(view.frame.width, defaultSize.width)
        let height = max(view.frame.height, defaultSize.height)
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: width, height: height)
    }
    
    private func layoutContainerGradientLayer() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        view.defaultStateViewGradientLayer.frame = view.defaultStateView.bounds
        view.defaultStateViewGradientLayer.cornerCurve = params.cornerCurve
        view.defaultStateViewGradientLayer.cornerRadius = view.defaultStateView.layer.cornerRadius
        CATransaction.commit()
    }
    
    private func layoutContainerViewInnerShadowLayer() {
        guard let containerViewInnerShadow = params.containerViewInnerShadow else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        view.containerViewInnerShadowLayer.frame = view.defaultStateView.bounds
        
        let path = UIBezierPath(
            roundedRect: view.defaultStateView.bounds.insetBy(
                dx: containerViewInnerShadow.innerOffset.width,
                dy: containerViewInnerShadow.innerOffset.height
            ),
            cornerRadius: view.defaultStateView.layer.cornerRadius
        )

        var cutOutPath = UIBezierPath(
            roundedRect: view.defaultStateView.bounds,
            cornerRadius: view.defaultStateView.layer.cornerRadius
        )
        cutOutPath = cutOutPath.reversing()
        path.append(cutOutPath)

        view.containerViewInnerShadowLayer.shadowPath = path.cgPath
        view.containerViewInnerShadowLayer.cornerCurve = params.cornerCurve

        CATransaction.commit()
    }
    
    private func layoutDefaultStateLabels() {
        let defaultLabels = view.defaultStateView.subviews.compactMap({$0 as? UILabel}).sorted(by: {$0.tag < $1.tag})
        
        for index in 0..<defaultLabels.count {
            let label = defaultLabels[index]
            let titleComponentsFrame = defaultTitleComponentsFrames[index]
            label.frame = titleComponentsFrame.text
        }
    }
    
    private func layoutDefaultStateImageViews() {
        let defaultImageViews = view.defaultStateView.subviews.compactMap({$0 as? UIImageView}).sorted(by: {$0.tag < $1.tag})
        
        for index in 0..<defaultImageViews.count {
            let imageView = defaultImageViews[index]
            let titleComponentsFrame = defaultTitleComponentsFrames[index]
            imageView.frame = titleComponentsFrame.image
        }
    }
    
    private func layoutSelectedtStateLabels() {
        let defaultLabels = view.selectedStateView.subviews.compactMap({$0 as? UILabel}).sorted(by: {$0.tag < $1.tag})
        
        for index in 0..<defaultLabels.count {
            let label = defaultLabels[index]
            let titleComponentsFrame = selectedTitleComponentsFrames[index]
            label.frame = titleComponentsFrame.text
        }
    }
    
    private func layoutSelectedStateImageViews() {
        let defaultImageViews = view.selectedStateView.subviews.compactMap({$0 as? UIImageView}).sorted(by: {$0.tag < $1.tag})
        
        for index in 0..<defaultImageViews.count {
            let imageView = defaultImageViews[index]
            let titleComponentsFrame = selectedTitleComponentsFrames[index]
            imageView.frame = titleComponentsFrame.image
        }
    }
}

extension TTSegmentedControlLayout {
    private func layoutSelectionView(for point: CGPoint) {
        let index = index(for: point)
        layoutSelectionView(for: index)
    }
    
    private func layoutSelectionView(for index: Int) {
        if selectionViewFrames.isEmpty { return }
        let frame = selectionViewFrames[index]
        layoutSelectionView(with: frame)
    }
    
    private func layoutSelectionView(with frame: CGRect) {
        view.selectionView.frame = frame

        let radiusRatio = view.defaultStateView.layer.cornerRadius / (0.5 * view.frame.height)
        view.selectionView.layer.cornerRadius = radiusRatio * (0.5 * view.selectionView.frame.height)
        view.selectionView.layer.cornerCurve = params.cornerCurve
    }
    
    private func layoutSelectionViewMask() {
        view.selectionViewMask.frame = view.selectionView.frame
        view.selectionViewMask.layer.cornerCurve = params.cornerCurve
        view.selectionViewMask.layer.cornerRadius = view.selectionView.layer.cornerRadius
    }
    
    private func layoutSelectionViewGradientLayer(animated: Bool = false) {
        if selectionViewFrames.isEmpty { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? params.animationDuration - 0.1 : 0.0)
        view.selectionViewGradientLayer.frame = view.selectionView.bounds
        view.selectionViewGradientLayer.cornerCurve = params.cornerCurve
        view.selectionViewGradientLayer.cornerRadius = view.selectionView.layer.cornerRadius
        CATransaction.commit()
    }
    
    private func layoutSelectionViewInnerShadowLayer(animated: Bool = false) {
        if selectionViewFrames.isEmpty { return }
        guard let selectionViewInnerShadow = params.selectionViewInnerShadow else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? params.animationDuration : 0.0)
        let path = UIBezierPath(
            roundedRect: view.selectionView.bounds.insetBy(
                dx: selectionViewInnerShadow.innerOffset.width,
                dy: selectionViewInnerShadow.innerOffset.height
            ),
            cornerRadius: view.selectionView.layer.cornerRadius
        )
        var cutOutPath = UIBezierPath(
            roundedRect: view.selectionView.bounds,
            cornerRadius: view.selectionView.layer.cornerRadius
        )
        cutOutPath = cutOutPath.reversing()
        path.append(cutOutPath)
        view.selectionViewInnerShadowLayer.frame = view.selectionView.bounds
        view.selectionViewInnerShadowLayer.shadowPath = path.cgPath
        view.selectionViewInnerShadowLayer.cornerCurve = params.cornerCurve
        view.selectionViewInnerShadowLayer.cornerRadius = view.selectionView.layer.cornerRadius
        CATransaction.commit()
    }
    
    func index(for point: CGPoint) -> Int {
        let builder = SelectedIndexBuilder(
            viewBounds: view.bounds,
            defaultTitleComponentsFrames: defaultTitleComponentsFrames,
            selectedTitleComponentsFrames: selectedTitleComponentsFrames,
            point: point,
            padding: params.padding,
            titleDistribution: params.titleDistribution
        )
        return builder.build()
    }
}
