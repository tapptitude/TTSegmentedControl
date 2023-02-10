//
//  TTSegmentedControlTitle+Addition.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 02.02.2023.
//

import UIKit

extension TTSegmentedControlTitle {
    var availableDefaultAttributedText: NSAttributedString {
        if let defaultAttributedText = defaultAttributedText {
            return defaultAttributedText
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: defaultColor,
            .font: defaultFont
        ]
        return NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    var availableSelectedAttributedText: NSAttributedString {
        if let selectedAttributedText = selectedAttributedText {
            return selectedAttributedText
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
        guard let defaultImageName = defaultImageName, let selectedImageName = selectedImageName else {
            return .zero
        }
        guard let defaultImage = UIImage(named: defaultImageName),
              let selectedImage = UIImage(named: selectedImageName)
        else {
            return .zero
        }
        return CGSize(
            width: max(defaultImage.size.width , selectedImage.size.width),
            height: max(defaultImage.size.height, selectedImage.size.height)
        )
    }
}
