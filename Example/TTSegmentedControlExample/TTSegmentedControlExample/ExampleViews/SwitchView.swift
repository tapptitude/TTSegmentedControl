//
//  SwitchView.swift
//  TTSegmentedControlExample
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import SwiftUI
import TTSegmentedControl

struct SwitchView: View {
    @State private var switchSelectedIndex: Int? = 0
    
    //MARK: selection view
    // dark mode
    let darkModeGradient = TTSegmentedControlGradient(
        startPoint: .init(x: 0, y: 0),
        endPoint: .init(x: 1, y: 1),
        colors: ["4F4F4F".color, "202020".color]
    )
    let darkModeBorder = TTSegmentedControlBorder(
        color: "757676".color.withAlphaComponent(0.7),
        lineWidth: 1.5)
    
    // light mode
    let lightModeGradient = TTSegmentedControlGradient(
        startPoint: .init(x: 0, y: 0),
        endPoint: .init(x: 1, y: 1),
        colors: ["F2F2F2".color, "D7D7D7".color]
    )
    let lightModeBorder = TTSegmentedControlBorder(
        color: "FFFFFF".color,
        lineWidth: 1.5)
    
    let selectionViewShadow = TTSegmentedControlShadow(
        color: "05000F".color,
        offset: CGSize(width: 0, height: 1),
        opacity: 0.36,
        radius: 2
    )
    var selectionViewBorder: TTSegmentedControlBorder {
        return switchSelectedIndex == 0 ?
        darkModeBorder :
        lightModeBorder
    }
    var selectionViewColorType: TTSegmentedControl.ColorType {
        return switchSelectedIndex == 0 ?
            .gradient(value: darkModeGradient) :
            .gradient(value: lightModeGradient)
    }
    
    //MARK: container view
    var containerColorType: TTSegmentedControl.ColorType {
        return switchSelectedIndex == 0 ?
            .color(value: "252525".color) :
            .color(value: "ECECEC".color)
    }
    
    let containerViewInnerShadow = TTSegmentedControlShadow(
        color: "B5B5B5".color,
        offset: CGSize(width: 0, height: 2),
        opacity: 1,
        radius: 2
    )
    
    var body: some View {
        TTSwiftUISegmentedControl(titles: switchTitles,
                                  selectedIndex: $switchSelectedIndex)
        .isSwitchBehaviorEnabled(true)
        .titleDistribution(.equalSpacing)
        .selectionViewFillType(.fillText)
        .selectionViewShadow(selectionViewShadow)
        .selectionViewBorder(selectionViewBorder)
        .selectionViewPadding(.init(width: 2, height: 2))
        .selectionViewColorType(selectionViewColorType)
        .containerColorType(containerColorType)
        .containerViewInnerShadow(containerViewInnerShadow)
        .frame(width: 80, height: 44)
    }
    
    private var switchTitles: [TTSegmentedControlTitle] {
        let darkModeTitle = TTSegmentedControlTitle(
            selectedImage: UIImage(named: "dark_mode"),
            imageSize: CGSize(width: 20, height: 20)
        )
        let lightModeTitle = TTSegmentedControlTitle(
            selectedImage: UIImage(named: "light_mode"),
            imageSize: CGSize(width: 20, height: 20)
        )
        return [darkModeTitle, lightModeTitle]
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView()
    }
}
