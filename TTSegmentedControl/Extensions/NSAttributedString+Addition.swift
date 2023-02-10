//
//  NSAttributedString+Addition.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 27.01.2023.
//

import UIKit

extension NSAttributedString {
    var textSize: CGSize {
        let size = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        let frame = boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return frame.size
    }
}
