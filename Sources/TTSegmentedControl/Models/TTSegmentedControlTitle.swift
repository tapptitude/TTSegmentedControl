//
//  TTSegmentedControlTitle.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 02.02.2023.
//

import UIKit

public struct TTSegmentedControlTitle {
    public let text: String?
    
    public let defaultColor: UIColor
    public let defaultFont: UIFont
    public let defaultAttributedText: NSAttributedString?
    public let defaultImageName: String?
    
    public let selectedColor: UIColor
    public let selectedFont: UIFont
    public let selectedAttributedText: NSAttributedString?
    public let selectedImageName: String?
    
    public let imageSize: CGSize?
    public let imagePosition: TTSegmentedControlTitle.ImagePosition
    public let spaceBetweenTextAndImage: CGFloat
    
    public init(
        text: String? = nil,
        defaultColor: UIColor = .black,
        defaultFont: UIFont = .systemFont(ofSize: 12),
        defaultAttributedText: NSAttributedString? = nil,
        defaultImageName: String? = nil,
        selectedColor: UIColor = .white,
        selectedFont: UIFont = .systemFont(ofSize: 12),
        selectedAttributedText: NSAttributedString? = nil,
        selectedImageName: String? = nil,
        imageSize: CGSize? = nil,
        imagePosition: TTSegmentedControlTitle.ImagePosition = .right,
        spaceBetweenTextAndImage: CGFloat = 5
    ) {
        self.text = text
        self.defaultColor = defaultColor
        self.defaultFont = defaultFont
        self.defaultAttributedText = defaultAttributedText
        self.defaultImageName = defaultImageName
        self.selectedColor = selectedColor
        self.selectedFont = selectedFont
        self.selectedAttributedText = selectedAttributedText
        self.selectedImageName = selectedImageName
        self.imageSize = imageSize
        self.imagePosition = imagePosition
        self.spaceBetweenTextAndImage = spaceBetweenTextAndImage
    }
}

extension TTSegmentedControlTitle {
    public enum ImagePosition {
        case left
        case right
        case top
        case bottom
    }
}
