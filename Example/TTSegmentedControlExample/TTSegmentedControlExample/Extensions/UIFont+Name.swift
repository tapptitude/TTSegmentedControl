//
//  UIFont+Name.swift
//  TTSegmentedControlExample
//
//  Created by Igor Dumitru on 15.03.2023.
//

import UIKit
import SwiftUI
extension UIFont {
    struct SFProText {
        static func medium(size: CGFloat) -> UIFont {
            UIFont.init(name: "SFProText-Medium", size: size)!
        }
    }
    
    struct PTSerif {
        static func bold(size: CGFloat) -> UIFont {
            UIFont.init(name: "PTSerif-Bold", size: size)!
        }
    }
    
    struct BeauRivage {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "BeauRivage-Regular", size: size)!
        }
    }
    
    struct DeliusSwashCaps {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "DeliusSwashCaps-Regular", size: size)!
        }
    }
}

extension Font {
    struct SFProText {
        static func medium(size: CGFloat) -> Font {
            Font.custom("SFProText-Medium", size: size)
        }
    }
}
