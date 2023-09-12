//
//  UIFont+Name.swift
//  TTSegmentedControlExample
//
//  Created by Igor Dumitru on 15.03.2023.
//

import UIKit
import SwiftUI

extension UIFont {
    struct Pacifico {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "Pacifico-Regular", size: size)!
        }
    }
    
    struct SigmarOne {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "SigmarOne-Regular", size: size)!
        }
    }
    
    struct PTSerif {
        static func bold(size: CGFloat) -> UIFont {
            UIFont.init(name: "PTSerif-Bold", size: size)!
        }
    }
    
    struct Outfit {
        static func medium(size: CGFloat) -> UIFont {
            UIFont.init(name: "Outfit-Medium", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont.init(name: "Outfit-SemiBold", size: size)!
        }
    }
    
    struct Koulen {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "Koulen-Regular", size: size)!
        }
    }
    
    struct Rubik {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.init(name: "Rubik-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont.init(name: "Rubik-SemiBold", size: size)!
        }
    }
}
