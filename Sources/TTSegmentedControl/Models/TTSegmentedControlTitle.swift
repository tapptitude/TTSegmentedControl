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
    public let defaultImage: UIImage?
    
    public let selectedColor: UIColor
    public let selectedFont: UIFont
    public let selectedAttributedText: NSAttributedString?
    public let selectedImage: UIImage?
    
    public let imageSize: CGSize?
    public let imagePosition: TTSegmentedControlTitle.ImagePosition
    public let spaceBetweenTextAndImage: CGFloat
    
    public init(
        text: String? = nil,
        defaultColor: UIColor = .black,
        defaultFont: UIFont = .systemFont(ofSize: 12),
        defaultImage: UIImage? = nil,
        selectedColor: UIColor = .white,
        selectedFont: UIFont = .systemFont(ofSize: 12),
        selectedImage: UIImage? = nil,
        imageSize: CGSize? = nil,
        imagePosition: TTSegmentedControlTitle.ImagePosition = .right,
        spaceBetweenTextAndImage: CGFloat = 5
    ) {
        self.text = text
        self.defaultColor = defaultColor
        self.defaultFont = defaultFont
        self.defaultAttributedText = nil
        self.defaultImage = defaultImage
        self.selectedColor = selectedColor
        self.selectedFont = selectedFont
        self.selectedAttributedText = nil
        self.selectedImage = selectedImage
        self.imageSize = imageSize
        self.imagePosition = imagePosition
        self.spaceBetweenTextAndImage = spaceBetweenTextAndImage
    }
    
    public init(
        defaultAttributedText: NSAttributedString,
        defaultImage: UIImage? = nil,
        selectedAttributedText: NSAttributedString,
        selectedImage: UIImage? = nil,
        imageSize: CGSize? = nil,
        imagePosition: TTSegmentedControlTitle.ImagePosition = .right,
        spaceBetweenTextAndImage: CGFloat = 5
    ) {
        self.text = nil
        self.defaultColor = .black
        self.defaultFont = .systemFont(ofSize: 12)
        self.defaultAttributedText = defaultAttributedText
        self.defaultImage = defaultImage
        self.selectedColor = .white
        self.selectedFont = .systemFont(ofSize: 12)
        self.selectedAttributedText = selectedAttributedText
        self.selectedImage = selectedImage
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
