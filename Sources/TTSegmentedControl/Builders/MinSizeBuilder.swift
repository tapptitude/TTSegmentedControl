//
//  MinSizeBuilder.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

struct MinSizeBuilder {
    private let defaultTextsSizes: [CGSize]
    private let selectedTextsSizes: [CGSize]
    private let imagesSizes: [CGSize]
    private let spaceBetweenTitleItems: [CGFloat]
    private let imagePositions: [TTSegmentedControlTitle.ImagePosition]
    private let currentBounds: CGSize
    private let cornerRadius: TTSegmentedControl.CornerRadius
    private let padding: CGSize
    private let titleDistribution: TTSegmentedControl.TitleDistribution
    private let defaultSpaceBetweenTexts: CGFloat = 18
    private var defaultTitlesTotalSizes = [CGSize]()
    private var selectedTitlesTotalSizes = [CGSize]()
    
    init(
        defaultTextsSizes: [CGSize],
        selectedTextsSizes: [CGSize],
        imagesSizes: [CGSize],
        spaceBetweenTitleItems: [CGFloat],
        imagePositions: [TTSegmentedControlTitle.ImagePosition],
        currentBounds: CGSize,
        cornerRadius: TTSegmentedControl.CornerRadius,
        padding: CGSize,
        titleDistribution: TTSegmentedControl.TitleDistribution
    ) {
        self.defaultTextsSizes = defaultTextsSizes
        self.selectedTextsSizes = selectedTextsSizes
        self.imagesSizes = imagesSizes
        self.spaceBetweenTitleItems = spaceBetweenTitleItems
        self.imagePositions = imagePositions
        self.currentBounds = currentBounds
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.titleDistribution = titleDistribution
        
        
        for index in 0..<defaultTextsSizes.count {
            let defaultTextsSize = totalSize(for: defaultTextsSizes[index], with: imagesSizes[index], at: imagePositions[index], withSpacing: spaceBetweenTitleItems[index])
            defaultTitlesTotalSizes.append(defaultTextsSize)
            
            let selectedTextsSize = totalSize(for: selectedTextsSizes[index], with: imagesSizes[index], at: imagePositions[index], withSpacing: spaceBetweenTitleItems[index])
            selectedTitlesTotalSizes.append(selectedTextsSize)
        }
    }
}

extension MinSizeBuilder {
    func build() -> CGSize {
        CGSize(width: maxWidth, height: maxHeight)
    }
}

extension MinSizeBuilder {
    private var maxHeight: CGFloat {
        let defaultTitlesHeight = defaultTitlesTotalSizes.map({$0.height}).max() ?? 0
        let selectedTitlesHeight = selectedTitlesTotalSizes.map({$0.height}).max() ?? 0
        return max(defaultTitlesHeight, selectedTitlesHeight) + 2 * padding.height
    }
}


extension MinSizeBuilder {
    private var maxWidth: CGFloat {
        switch titleDistribution {
        case .fillEqually:
            return maxWidthForFillEquallyDistribution
        case .equalSpacing:
            return maxWidthForEqualSpacingDistribution
        }
    }
    
    private var maxWidthForFillEquallyDistribution: CGFloat {
        let defaultTexstMaxWidth = defaultTitlesTotalSizes.map({$0.width}).max() ?? 0
        let selectedTextsMaxWidth = selectedTitlesTotalSizes.map({$0.width}).max() ?? 0
        let maxWidth = max(defaultTexstMaxWidth, selectedTextsMaxWidth) + defaultSpaceBetweenTexts
        let totalWidth = CGFloat(defaultTitlesTotalSizes.count) * maxWidth + 2 * padding.width
        return totalWidth
    }
    
    private var maxWidthForEqualSpacingDistribution: CGFloat {
        let defaultTitlesWidth = maxWidth(for: defaultTitlesTotalSizes)
        let selectedTitlesWidth = maxWidth(for: selectedTitlesTotalSizes)
        let totalWidth = max(defaultTitlesWidth, selectedTitlesWidth) + 2 * padding.width
        return totalWidth
    }
}

extension MinSizeBuilder {
    private func maxWidth(for titlesSizes: [CGSize]) -> CGFloat {
        let titlesMaxWidth = totalWidth(for: titlesSizes)
        return titlesMaxWidth + (CGFloat(titlesSizes.count) * defaultSpaceBetweenTexts)
    }
    
    private func totalWidth(for titlesSizes: [CGSize]) -> CGFloat {
        titlesSizes.map({width(for: $0)}).reduce(0, +)
    }
    
    private func width(for textSize: CGSize) -> CGFloat {
        let minWidth = 2 * selectionViewCornerRadius
        return max(textSize.width, minWidth)
    }

    private var selectionViewCornerRadius: CGFloat {
        let height = max(currentBounds.height, maxHeight)
        
        var cornerRadius: CGFloat = 0
        switch self.cornerRadius {
        case .none:
            cornerRadius = 0
        case .maximum:
            cornerRadius = 0.5 * height
        case .constant(let value):
            cornerRadius = max(0, min(value, 0.5 * height))
        }

        let radiusRatio = cornerRadius / (0.5 * height)
        let selectionViewHeight = height - 2 * padding.height
        return 0.5 * (radiusRatio * selectionViewHeight)
    }
    
    private func totalSize(
        for textSize: CGSize,
        with imageSize: CGSize,
        at position: TTSegmentedControlTitle.ImagePosition,
        withSpacing spacing: CGFloat
    ) -> CGSize {
        var width = textSize.width
        var height = textSize.height
        let spacing = imageSize == .zero || textSize == .zero ? 0 : spacing
        
        switch position {
        case .top, .bottom:
            width = max(imageSize.width, textSize.width)
            height = imageSize.height + spacing + textSize.height
        case .left, .right:
            width =  imageSize.width + spacing + textSize.width
            height = max(imageSize.height, textSize.height)
        }
        return CGSize(width: width, height: height)
    }
}
