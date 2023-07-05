//
//  SelectionViewFrameForPointBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 03.02.2023.
//

import UIKit

struct SelectionViewFrameForPointBuilder {
    private let viewBounds: CGRect
    private let point: CGPoint
    private let isMovingToLeft: Bool
    private let selectedTitleComponentsFrames: [TitleComponentFrame]
    private let selectionViewFrames: [CGRect]
    
    init(
        viewBounds: CGRect,
        point: CGPoint,
        isMovingToLeft: Bool,
        selectedTitleComponentsFrames: [TitleComponentFrame],
        selectionViewFrames: [CGRect]
    ) {
        self.viewBounds = viewBounds
        self.point = point
        self.isMovingToLeft = isMovingToLeft
        self.selectedTitleComponentsFrames = selectedTitleComponentsFrames
        self.selectionViewFrames = selectionViewFrames
    }
}

extension SelectionViewFrameForPointBuilder {
    func build() -> CGRect? {
        let positionX = max(0, min(point.x, viewBounds.width - 1))
        let point = CGPoint(x: positionX, y: 0.5 * viewBounds.height)
        
        guard let sectionFrame = segmentViewSectionsFrames.filter({$0.contains(point)}).first else {
            return nil
        }
        let labelsFrames = selectedTitleComponentsFrames.map({$0.total})
        let labelFramesForPoint = labelsFrames.filter({$0.intersects(sectionFrame)})
        let leadingIndex = labelsFrames.firstIndex(where: {$0.midX == labelFramesForPoint.first!.midX})!
        let trailingIndex = labelsFrames.firstIndex(where: {$0.midX == labelFramesForPoint.last!.midX})!
        
        var frame = selectionViewFrames.first!
        
        if isMovingToLeft {
            let leadingFrame = selectionViewFrames[leadingIndex]
            let currentFrame = selectionViewFrames[trailingIndex]
            let ratio = (point.x - leadingFrame.midX) / (currentFrame.midX - leadingFrame.midX)
            let widthDifference = currentFrame.width - leadingFrame.width
            let width = leadingFrame.width + ratio * widthDifference
            let originX = point.x - 0.5 * width
            frame = CGRect(x: originX, y: leadingFrame.origin.y, width: width, height: leadingFrame.height)
        } else {
            let currentFrame = selectionViewFrames[leadingIndex]
            let trailingFrame = selectionViewFrames[trailingIndex]
            let ratio = (trailingFrame.midX - point.x) / (trailingFrame.midX - currentFrame.midX)
            let widthDifference = currentFrame.width - trailingFrame.width
            let width = trailingFrame.width + ratio * widthDifference
            let originX = point.x - 0.5 * width
            frame = CGRect(x: originX, y: trailingFrame.origin.y, width: width, height: trailingFrame.height)
        }
        return frame
    }
}

extension SelectionViewFrameForPointBuilder {
    private var segmentViewSectionsFrames: [CGRect] {
        let labelsFrame = selectedTitleComponentsFrames.map({$0.total})
        
        var frames = [CGRect]()
        
        for index in 0..<labelsFrame.count {
            let nextIndex = index + 1
            if nextIndex > labelsFrame.count - 1 { continue }
            let frame1 = labelsFrame[index]
            let frame2 = labelsFrame[nextIndex]
            let frame = CGRect(x: frame1.midX, y: frame1.origin.y, width: frame2.midX - frame1.midX, height: frame1.height)
            frames.append(frame)
        }
        
        return frames
    }
}
