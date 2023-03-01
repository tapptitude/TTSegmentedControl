//
//  TTSegmentedControlTitle+Addition.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 02.02.2023.
//

import UIKit

extension TTSegmentedControlTitle {
    var availableDefaultAttributedText: NSAttributedString {
        if let defaultAttributedText = defaultAttributedText ?? selectedAttributedText {
            var attributes = defaultAttributedText.attributes(at: 0, effectiveRange: nil)
            attributes[.foregroundColor] = attributes[.foregroundColor] ?? defaultColor
            attributes[.font] = attributes[.font] ?? defaultFont
            return NSAttributedString(string: defaultAttributedText.string, attributes: attributes)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: defaultColor,
            .font: defaultFont
        ]
        return NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    var availableSelectedAttributedText: NSAttributedString {
        if let selectedAttributedText = selectedAttributedText ?? defaultAttributedText {
            var attributes = selectedAttributedText.attributes(at: 0, effectiveRange: nil)
            attributes[.foregroundColor] = attributes[.foregroundColor] ?? selectedColor
            attributes[.font] = attributes[.font] ?? selectedFont
            return NSAttributedString(string: selectedAttributedText.string, attributes: attributes)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedColor,
            .font: selectedFont
        ]
        return NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    var availableImageSize: CGSize {
        if let imageSize = imageSize {
            return imageSize
        }
        guard let defaultImage = defaultImage, let selectedImage = selectedImage else {
            return .zero
        }
        return CGSize(
            width: max(defaultImage.size.width , selectedImage.size.width),
            height: max(defaultImage.size.height, selectedImage.size.height)
        )
    }
}
