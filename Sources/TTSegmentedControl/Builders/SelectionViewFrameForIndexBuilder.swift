//
//  SelectionViewFrameForIndexBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 30.01.2023.
//

import UIKit

struct SelectionViewFrameForIndexBuilder {
    private let viewBounds: CGRect
    private let defaultTitleComponentsFrames: [TitleComponentFrame]
    private let selectedTitleComponentsFrames: [TitleComponentFrame]
    private let index: Int
    private let padding: CGSize
    private let selectionViewFillType: TTSegmentedControl.SelectionViewFillType
    
    init(
        viewBounds: CGRect,
        defaultTitleComponentsFrames: [TitleComponentFrame],
        selectedTitleComponentsFrames: [TitleComponentFrame],
        index: Int,
        padding: CGSize,
        selectionViewFillType: TTSegmentedControl.SelectionViewFillType
    ) {
        self.viewBounds = viewBounds
        self.defaultTitleComponentsFrames = defaultTitleComponentsFrames
        self.selectedTitleComponentsFrames = selectedTitleComponentsFrames
        self.index = index
        self.padding = padding
        self.selectionViewFillType = selectionViewFillType
    }
}

extension SelectionViewFrameForIndexBuilder {
    func build() -> CGRect {
        let sectionWidth = defaultTitleComponentsFrames.count == 0
            ? 0
            : (viewBounds.width - 2 * padding.width) / CGFloat(defaultTitleComponentsFrames.count)
        
        let itemsCount = selectedTitleComponentsFrames.count
        if selectedTitleComponentsFrames.isEmpty { return .zero }
        let totalFreeSpace = (viewBounds.width - 2 * padding.width) - selectedTitleComponentsFrames.map({$0.total.width}).reduce(0, +)
        
        let spaceBetweenLabels = totalFreeSpace / CGFloat(itemsCount)
        let widthOffset = min(18, spaceBetweenLabels)
        
        var frame = selectedTitleComponentsFrames[index].total
        frame.origin.y = padding.height
        frame.size.height = viewBounds.height - 2 * frame.origin.y
        
        if index == 0 {
            frame.size.width = 2 * (frame.midX - padding.width)
            frame.origin.x = padding.width
        } else if index == itemsCount - 1 {
            let rightMargin = viewBounds.width - padding.width
            frame.size.width = 2 * (rightMargin - frame.midX)
            frame.origin.x = rightMargin - frame.size.width
        } else if selectionViewFillType == .fillText {
            frame.origin.x = frame.origin.x - 0.5 * widthOffset
            frame.size.width = frame.size.width + widthOffset
        } else {
            frame.origin.x = frame.midX - 0.5 * sectionWidth
            frame.size.width = sectionWidth
        }
        return frame
    }
}
