//
//  Example1View.swift
//  TTSegmentedControlExample
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import SwiftUI
import TTSegmentedControl

struct Example1View: View {
    var body: some View {
        TTSwiftUISegmentedControl(titles: segmentedControlTitles)
            .titleDistribution(.fillEqually)
            .selectionViewFillType(.fillSegment)
            .containerColorType(.color(value: "263142".color))
            .selectionViewColorType(.gradient(value: gradient))
            .selectionViewPadding(CGSize(width: 8, height: 8))
            .frame(height: 56)    }
    
    let gradient = TTSegmentedControlGradient(
        startPoint: .init(x: 0, y: 0.5),
        endPoint: .init(x: 1, y: 0.5),
        colors: ["255AE3".color, "26B1B1".color]
    )
    
    var segmentedControlTitles: [TTSegmentedControlTitle] {
        let menTitle = TTSegmentedControlTitle(
            text: "Men",
            defaultColor: .white,
            defaultFont: .PTSerif.bold(size: 16),
            selectedColor: .white,
            selectedFont: .PTSerif.bold(size: 16)
        )
        let womenTitle = TTSegmentedControlTitle(
            text: "Women",
            defaultColor: .white,
            defaultFont: .Pacifico.regular(size: 16),
            selectedColor: .white,
            selectedFont: .Pacifico.regular(size: 16)
        )
        let kidsTitle = TTSegmentedControlTitle(
            text: "Kids",
            defaultColor: .white,
            defaultFont: .SigmarOne.regular(size: 16),
            selectedColor: .white,
            selectedFont: .SigmarOne.regular(size: 16)
        )
        return [menTitle, womenTitle, kidsTitle]
    }
}

struct Example1View_Previews: PreviewProvider {
    static var previews: some View {
        Example1View()
    }
}
