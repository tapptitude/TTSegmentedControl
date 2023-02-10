//
//  UIView+Animation.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 31.01.2023.
//

import UIKit

extension UIView {
    class func animate(
        with animationOptions: TTSegmentedControlAnimationOption,
        using bounceOptions: TTSegmentedControlBounceOptions,
        animations: @escaping (() -> Void)
    ) {
        UIView.animate(
            withDuration: animationOptions.duration,
            delay: 0,
            usingSpringWithDamping: bounceOptions.springDamping,
            initialSpringVelocity: bounceOptions.springInitialVelocity,
            options: animationOptions.options,
            animations: animations,
            completion: nil
        )
    }
    
    class func animate(
        with animationOptions: TTSegmentedControlAnimationOption,
        animations: @escaping (() -> Void)
    ) {
        UIView.animate(
            withDuration: animationOptions.duration,
            delay: 0.0,
            options: animationOptions.options,
            animations: animations, completion: nil
        )
    }
}
