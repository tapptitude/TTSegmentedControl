//
//  Example5View.swift
//  TTSegmentedControlExample
//
//  Created by Daria Andrioaie on 24.08.2023.
//

import SwiftUI
import TTSegmentedControl

struct Example4View: View {
    let innerShadow = TTSegmentedControlShadow(
        color: .black,
        offset: CGSize(width: 0, height: 3),
        innerOffset: CGSize(width: 0, height: -17),
        opacity: 0.25,
        radius: 4)
    
    var body: some View {
        TTSwiftUISegmentedControl(titles: segmentControlTitles)
            .bounceAnimationOptions(.init())
            .containerColorType(.color(value: "F8F2EC".color))
            .selectionViewColorType(.color(value: "EF8C30".color))
            .cornerRadius(.maximum)
            .selectionViewPadding(.init(width: 4, height: 4))
            .selectionViewInnerShadow(innerShadow)
            .frame(height: 52)
    }
    
    private var segmentControlTitles: [TTSegmentedControlTitle] {
        ["XS", "S", "M", "L", "XL"].map { title in
            TTSegmentedControlTitle(
                text: title,
                defaultColor: "9A8F86".color,
                defaultFont: .Rubik.regular(size: 18),
                selectedColor: .white,
                selectedFont: .Rubik.semiBold(size: 18)
            )
        }
    }
}

struct Example5View_Previews: PreviewProvider {
    static var previews: some View {
        Example4View()
    }
}
