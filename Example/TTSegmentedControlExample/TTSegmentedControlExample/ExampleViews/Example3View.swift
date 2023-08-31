//
//  Example4View.swift
//  TTSegmentedControlExample
//
//  Created by Daria Andrioaie on 23.08.2023.
//

import SwiftUI
import TTSegmentedControl

struct Example3View: View {
    var body: some View {
        TTSwiftUISegmentedControl(titles: segmentedControlTitles)
            .containerColorType(.color(value: "EEF3FF".color))
            .selectionViewColorType(.color(value: "4B3CFA".color))
            .bounceAnimationOptions( .init())
            .cornerRadius(.constant(value: 4))
            .selectionViewPadding(.zero)
            .frame(height: 48)
    }
    
    private var segmentedControlTitles: [TTSegmentedControlTitle] {
        let accountTitle = TTSegmentedControlTitle(
            text: "Account",
            defaultColor: "4B3CFA".color,
            defaultFont: .Outfit.medium(size: 14),
            defaultImage: UIImage(named: "account"),
            selectedColor: .white,
            selectedFont: .Outfit.semiBold(size: 14),
            selectedImage: UIImage(named: "account")?.withTintColor(.white),
            imagePosition: .left,
            spaceBetweenTextAndImage: 4
        )
        let settingsTitle = TTSegmentedControlTitle(
            text: "Settings",
            defaultColor: "4B3CFA".color,
            defaultFont: .Outfit.medium(size: 14),
            defaultImage: UIImage(named: "settings"),
            selectedColor: .white,
            selectedFont: .Outfit.semiBold(size: 14),
            selectedImage: UIImage(named: "settings")?.withTintColor(.white),
            imagePosition: .left,
            spaceBetweenTextAndImage: 4
        )
        let billingTitle = TTSegmentedControlTitle(
            text: "Billing",
            defaultColor: "4B3CFA".color,
            defaultFont: .Outfit.medium(size: 14),
            defaultImage: UIImage(named: "billing"),
            selectedColor: .white,
            selectedFont: .Outfit.semiBold(size: 14),
            selectedImage: UIImage(named: "billing")?.withTintColor(.white),
            imagePosition: .left,
            spaceBetweenTextAndImage: 4
        )
        return [accountTitle, settingsTitle, billingTitle]
    }
}

struct Example4View_Previews: PreviewProvider {
    static var previews: some View {
        Example3View()
    }
}
