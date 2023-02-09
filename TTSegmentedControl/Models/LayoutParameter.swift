//
//  LayoutParameter.swift
//  SegmentedControl
//
//  Created by Igor Dumitru on 31.01.2023.
//

import Foundation

struct LayoutParameter {
    let defaultTextsSizes: [CGSize]
    let imagesSizes: [CGSize]
    let selectedTextsSizes: [CGSize]
    let spaceBetweenTitleItems: [CGFloat]
    let imagePositions: [TTSegmentedControlTitle.ImagePosition]
    let selectedIndex: Int
    let padding: CGSize
    let cornerRadius: CGFloat
    let isSizeAdjustEnabled: Bool
    let titleDistribution: TTSegmentedControl.TitleDistribution
    let animationDuration: TimeInterval
    
    init(
        defaultTitlesSizes: [CGSize],
        selectedTitlesSizes: [CGSize],
        spaceBetweenTitleItems: [CGFloat],
        imagesSizes: [CGSize],
        imagePositions: [TTSegmentedControlTitle.ImagePosition],
        selectedIndex: Int,
        padding: CGSize,
        cornerRadius: CGFloat,
        isSizeAdjustEnabled: Bool,
        titleDistribution: TTSegmentedControl.TitleDistribution,
        animationDuration: TimeInterval
    ) {
        self.defaultTextsSizes = defaultTitlesSizes
        self.selectedTextsSizes = selectedTitlesSizes
        self.spaceBetweenTitleItems = spaceBetweenTitleItems
        self.imagesSizes = imagesSizes
        self.imagePositions = imagePositions
        self.selectedIndex = selectedIndex
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.isSizeAdjustEnabled = isSizeAdjustEnabled
        self.titleDistribution = titleDistribution
        self.animationDuration = animationDuration
    }
}
