//
//  TextLabelsFrameListBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 30.01.2023.
//

import UIKit

struct TitleComponentFrameListBuilder {
    private let viewBounds: CGRect
    private let cornerRadius: TTSegmentedControl.CornerRadius
    private let textsSizes: [CGSize]
    private let imagesSizes: [CGSize]
    private let spaceBetweenTitleItems: [CGFloat]
    private let imagePositions: [TTSegmentedControlTitle.ImagePosition]
    private let padding: CGSize
    private let titleDistribution: TTSegmentedControl.TitleDistribution
    
    init(
        viewBounds: CGRect,
        cornerRadius: TTSegmentedControl.CornerRadius,
        textsSizes: [CGSize],
        imagesSizes: [CGSize],
        spaceBetweenTitleItems: [CGFloat],
        imagePositions: [TTSegmentedControlTitle.ImagePosition],
        padding: CGSize,
        titleDistribution: TTSegmentedControl.TitleDistribution
    ) {
        self.viewBounds = viewBounds
        self.cornerRadius = cornerRadius
        self.textsSizes = textsSizes
        self.imagesSizes = imagesSizes
        self.spaceBetweenTitleItems = spaceBetweenTitleItems
        self.imagePositions = imagePositions
        self.padding = padding
        self.titleDistribution = titleDistribution
    }
}

extension TitleComponentFrameListBuilder {
    func build() -> [TitleComponentFrame] {

        var items = [TitleComponentFrame]()
        let maxFrames = titleDistribution == .equalSpacing
            ? maxTitleItemFramesForEqualSpaceBetweenItems
            : maxTitleItemsFrameWhenFillEqualWidth
        
        for index in 0..<textsSizes.count {
            let textSize = textsSizes[index]
            let imageSize = imagesSizes[index]
            let imagePosition = imagePositions[index]
            let spaceBetweenItems = spaceBetweenTitleItems[index]
            let maxTitleItemFrame = maxFrames[index]
            
            let imageAndTextSize = self.imageAndTextSize(
                for: textSize,
                with: imageSize,
                at: imagePosition,
                withSpacing: spaceBetweenItems
            )
            
            let imageAndTextTotalFrame = CGRect(
                x: maxTitleItemFrame.origin.x + 0.5 * (maxTitleItemFrame.width - imageAndTextSize.width),
                y: maxTitleItemFrame.origin.y + 0.5 * (maxTitleItemFrame.height - imageAndTextSize.height),
                width: imageAndTextSize.width,
                height: imageAndTextSize.height
            )
            
            let textFrame = textFrame(
                inside: imageAndTextTotalFrame,
                for: textSize,
                and: imageSize,
                whenImagePositionIsOn: imagePosition
            )

            let iamageFrame = imageFrame(
                inside: imageAndTextTotalFrame,
                for: textSize,
                and: imageSize,
                whenImagePositionIsOn: imagePosition
            )
            
            let componentsFrame = TitleComponentFrame(
                text: textFrame,
                image: iamageFrame,
                total: maxTitleItemFrame
            )
            
            items.append(componentsFrame)
        }
        return items
    }
}

extension TitleComponentFrameListBuilder {
    func textFrame(
        inside
        totalFrame: CGRect,
        for textSize: CGSize,
        and imageSize: CGSize,
        whenImagePositionIsOn imagePosition: TTSegmentedControlTitle.ImagePosition
    ) -> CGRect {
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        
        if imageSize == .zero {
            originX = totalFrame.origin.x + 0.5 * (totalFrame.width - textSize.width)
            originY = totalFrame.origin.y + 0.5 * (totalFrame.height - textSize.height)
        } else {
            switch imagePosition {
            case .left:
                originX = totalFrame.maxX - textSize.width
                originY = totalFrame.origin.y + 0.5 * (totalFrame.height - textSize.height)
            case .right:
                originX = totalFrame.origin.x
                originY = totalFrame.origin.y + 0.5 * (totalFrame.height - textSize.height)
            case .top:
                originX = totalFrame.origin.x + 0.5 * (totalFrame.width - textSize.width)
                originY = totalFrame.maxY - textSize.height
            case .bottom:
                originX = totalFrame.origin.x + 0.5 * (totalFrame.width - textSize.width)
                originY = totalFrame.origin.y
            }
        }
        
        return CGRect(x: originX, y: originY, width: textSize.width, height: textSize.height)
    }
    
    func imageFrame(
        inside
        totalFrame: CGRect,
        for textSize: CGSize,
        and imageSize: CGSize,
        whenImagePositionIsOn imagePosition: TTSegmentedControlTitle.ImagePosition
    ) -> CGRect {
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        
        if textSize == .zero {
            originX = totalFrame.origin.x + 0.5 * (totalFrame.width - imageSize.width)
            originY = totalFrame.origin.y + 0.5 * (totalFrame.height - imageSize.height)
        } else {
            switch imagePosition {
            case .left:
                originX = totalFrame.origin.x
                originY = totalFrame.origin.y + 0.5 * (totalFrame.height - imageSize.height)
            case .right:
                originX = totalFrame.maxX - imageSize.width
                originY = totalFrame.origin.y + 0.5 * (totalFrame.height - imageSize.height)
            case .top:
                originX = totalFrame.origin.x + 0.5 * (totalFrame.width - imageSize.width)
                originY = totalFrame.origin.y
            case .bottom:
                originX = totalFrame.origin.x + 0.5 * (totalFrame.width - imageSize.width)
                originY = totalFrame.maxY - imageSize.height
            }
        }
        return CGRect(
            x: originX,
            y: originY,
            width: imageSize.width,
            height: imageSize.height
        )
    }
}

extension TitleComponentFrameListBuilder {
    private var maxTitleItemsFrameWhenFillEqualWidth: [CGRect] {
        let sectionWidth = textsSizes.count == 0
            ? 0
            : (viewBounds.width - 2 * padding.width) / CGFloat(textsSizes.count)
        var frames = [CGRect]()
        for index in 0..<textsSizes.count {
            let totalSize = titlesTotalSizes[index]
            let width = width(for: totalSize)
            let originX = CGFloat(index) * sectionWidth + 0.5 * (sectionWidth - width)
            
            let frame = CGRect(
                x: originX,
                y: 0,
                width: width,
                height: viewBounds.height
            )
            frames.append(frame)
        }
        return frames
    }
    
    private var maxTitleItemFramesForEqualSpaceBetweenItems: [CGRect] {
        let textsTotalWidth = totalWidth(for: titlesTotalSizes)
        let spaceBetweenItems = textsSizes.count == 0
            ? 0
            : (viewBounds.width - 2 * padding.width - textsTotalWidth) / CGFloat(textsSizes.count)
        
        var originX = padding.width + 0.5 * spaceBetweenItems
        
        
        var frames = [CGRect]()
        for index in 0..<textsSizes.count {
            let totalSize = titlesTotalSizes[index]
            
            let frame = CGRect(
                x: originX,
                y: 0,
                width: width(for: totalSize),
                height: viewBounds.height
            )
            
            frames.append(frame)
            
            originX = frame.maxX + spaceBetweenItems
        }
        return frames
    }
    
    private func width(for titleSize: CGSize) -> CGFloat {
        let minWidth = 2 * selectionViewCornerRadius
        return max(titleSize.width, minWidth)
    }
    
    private func totalWidth(for sizes: [CGSize]) -> CGFloat {
        sizes.map({width(for: $0)}).reduce(0, +)
    }

    private var selectionViewCornerRadius: CGFloat {
        let cornerRadius = CornerRadiusBuilder(frame: viewBounds, cornerRadius: self.cornerRadius).build()
        let radiusRatio = cornerRadius / (0.5 * viewBounds.height)
        let selectionViewHeight = viewBounds.height - 2 * padding.height
        return 0.5 * (radiusRatio * selectionViewHeight)
    }
}

extension TitleComponentFrameListBuilder {
    private var titlesTotalSizes: [CGSize] {
        var sizes = [CGSize]()
        for index in 0..<textsSizes.count {
            let textSize = textsSizes[index]
            let imageSize = imagesSizes[index]
            let spaceBetweenItems = spaceBetweenTitleItems[index]
            let imagePosition = imagePositions[index]
            let totalSize = imageAndTextSize(for: textSize, with: imageSize, at: imagePosition, withSpacing: spaceBetweenItems)
            sizes.append(totalSize)
        }
        return sizes
    }
    
    private func imageAndTextSize(
        for textSize: CGSize,
        with imageSize: CGSize,
        at position: TTSegmentedControlTitle.ImagePosition,
        withSpacing spacing: CGFloat
    ) -> CGSize {
        var width = textSize.width
        var height = textSize.height
        let isTextMissing = textSize.width == 0 || textSize.height == 0
        
        let spacing = imageSize == .zero || isTextMissing ? 0 : spacing
        
        switch position {
        case .top, .bottom:
            width = max(imageSize.width, textSize.width)
            height = imageSize.height + spacing + textSize.height
        case .left, .right:
            width = imageSize.width + spacing + textSize.width
            height = max(imageSize.height, textSize.height)
        }
        return CGSize(width: width, height: height)
    }
}
