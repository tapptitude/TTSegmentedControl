//
//  Example2View.swift
//  TTSegmentedControlExample
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import SwiftUI
import TTSegmentedControl

struct Example2View: View {
    let gradient = TTSegmentedControlGradient(
        startPoint: .init(x: 0, y: 0.5),
        endPoint: .init(x: 1, y: 0.5),
        colors: ["F9AF86".color.withAlphaComponent(0.76),
                 "C5DD2F".color.withAlphaComponent(0.4)]
    )
    let border = TTSegmentedControlBorder(color: .black)
    
    private var segmentControlTitles: [TTSegmentedControlTitle] {
        ["men", "women", "kids"].map { title in
            TTSegmentedControlTitle(
                text: title.uppercased(),
                defaultColor: "939393".color,
                defaultFont: .Koulen.regular(size: 14),
                selectedColor: .black,
                selectedFont: .Koulen.regular(size: 14)
            )
        }
    }
    
    var body: some View {
        TTSwiftUISegmentedControl(titles: segmentControlTitles)
            .selectionViewColorType(.gradient(value: gradient))
            .bounceAnimationOptions( .init())
            .cornerRadius( .constant(value: 10))
            .selectionViewPadding(.init(width: 4, height: 4))
            .selectionViewBorder(border)
            .containerViewBorder(border)
            .frame(height: 48)
    }
}

struct Example2View_Previews: PreviewProvider {
    static var previews: some View {
        Example2View()
    }
}
