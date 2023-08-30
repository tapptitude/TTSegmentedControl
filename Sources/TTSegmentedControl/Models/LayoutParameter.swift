//
//  LayoutParameter.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 31.01.2023.
//

import UIKit

struct LayoutParameter {
    let defaultTextsSizes: [CGSize]
    let imagesSizes: [CGSize]
    let selectedTextsSizes: [CGSize]
    let spaceBetweenTitleItems: [CGFloat]
    let imagePositions: [TTSegmentedControlTitle.ImagePosition]
    let selectedIndex: Int
    let padding: CGSize
    let cornerRadius: TTSegmentedControl.CornerRadius
    let cornerCurve: CALayerCornerCurve
    let isSizeAdjustEnabled: Bool
    let titleDistribution: TTSegmentedControl.TitleDistribution
    let selectionViewFillType: TTSegmentedControl.SelectionViewFillType
    let selectionViewInnerShadow: TTSegmentedControlShadow?
    let animationDuration: TimeInterval
    let containerViewInnerShadow: TTSegmentedControlShadow?
    
    init(
        defaultTitlesSizes: [CGSize],
        selectedTitlesSizes: [CGSize],
        spaceBetweenTitleItems: [CGFloat],
        imagesSizes: [CGSize],
        imagePositions: [TTSegmentedControlTitle.ImagePosition],
        selectedIndex: Int,
        padding: CGSize,
        cornerRadius: TTSegmentedControl.CornerRadius,
        cornerCurve: CALayerCornerCurve,
        isSizeAdjustEnabled: Bool,
        titleDistribution: TTSegmentedControl.TitleDistribution,
        selectionViewFillType: TTSegmentedControl.SelectionViewFillType,
        selectionViewInnerShadow: TTSegmentedControlShadow?,
        animationDuration: TimeInterval,
        containerViewInnerShadow: TTSegmentedControlShadow?
    ) {
        self.defaultTextsSizes = defaultTitlesSizes
        self.selectedTextsSizes = selectedTitlesSizes
        self.spaceBetweenTitleItems = spaceBetweenTitleItems
        self.imagesSizes = imagesSizes
        self.imagePositions = imagePositions
        self.selectedIndex = selectedIndex
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.cornerCurve = cornerCurve
        self.isSizeAdjustEnabled = isSizeAdjustEnabled
        self.titleDistribution = titleDistribution
        self.selectionViewFillType = selectionViewFillType
        self.selectionViewInnerShadow = selectionViewInnerShadow
        self.animationDuration = animationDuration
        self.containerViewInnerShadow = containerViewInnerShadow
    }
}
