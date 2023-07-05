//
//  SelectedIndexBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 30.01.2023.
//

import UIKit

struct SelectedIndexBuilder {
    private let viewBounds: CGRect
    private let defaultTitleComponentsFrames: [TitleComponentFrame]
    private let selectedTitleComponentsFrames: [TitleComponentFrame]
    private let point: CGPoint
    private let padding: CGSize
    private let titleDistribution: TTSegmentedControl.TitleDistribution
    
    init(
        viewBounds: CGRect,
        defaultTitleComponentsFrames: [TitleComponentFrame],
        selectedTitleComponentsFrames: [TitleComponentFrame],
        point: CGPoint,
        padding: CGSize,
        titleDistribution: TTSegmentedControl.TitleDistribution
    ) {
        self.viewBounds = viewBounds
        self.defaultTitleComponentsFrames = defaultTitleComponentsFrames
        self.selectedTitleComponentsFrames = selectedTitleComponentsFrames
        self.point = point
        self.padding = padding
        self.titleDistribution = titleDistribution
    }
}

extension SelectedIndexBuilder {
    func build() -> Int {
        let segmentFrames = segmentFrames
        let x = min(max(0, point.x), viewBounds.width - 1)
        let newPoint = CGPoint(x: x, y: 0.5 * viewBounds.height)
        return segmentFrames.firstIndex(where: {$0.contains(newPoint)}) ?? 0
    }
}

extension SelectedIndexBuilder {
    private var segmentFrames: [CGRect] {
        var frames = [CGRect]()
        
        var index = 0
        while index < selectedTitleComponentsFrames.count {
            let isLastItem = index == selectedTitleComponentsFrames.count - 1
            let isFirstItem = index == 0
            
            let nextMidX = isLastItem ? viewBounds.maxX : selectedTitleComponentsFrames[index + 1].total.midX
            let previousMidX = isFirstItem ? 0 : selectedTitleComponentsFrames[index - 1].total.midX
            
            let currentMidX = selectedTitleComponentsFrames[index].total.midX
            let middleDistanceToNextItem = 0.5 * (nextMidX - currentMidX)
            let middleDistanceToPrevousItem = 0.5 * (currentMidX - previousMidX)
            
            let originX = isFirstItem
                ? 0
                : currentMidX - middleDistanceToPrevousItem
            let rightMargin = isLastItem
                ? viewBounds.maxX
                : currentMidX + middleDistanceToNextItem
            
            let width = rightMargin - originX

            let frame = CGRect(x: originX, y: 0, width: width, height: viewBounds.height)
            frames.append(frame)
            index = index + 1
        }
        return frames
    }
}
