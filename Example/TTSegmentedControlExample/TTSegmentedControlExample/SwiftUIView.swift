//
//  SwiftUIView.swift
//  SegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import SwiftUI
import TTSegmentedControl

struct SwiftUIView: View {
    
    var body: some View {
        ZStack {
            if #available(iOS 14.0, *) {
                Color("EAEAEA".color).ignoresSafeArea()
            } else {
                Color("EAEAEA".color)
            }
       
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    firstSegmentedControlSection
                    secondSegmentedControlSection
                    thirdSegmentedControlSection
                    fourthSegmentedControlSection
                }
                .padding(.horizontal, 24)
                switchViewSection
            }
        }
    }
}

extension SwiftUIView {
    private var firstSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "ROUNDED CORNERS", description: "Equal space between titles")
            firstSegemntedControl
        }
    }
    
    private var firstSegmentControlTitles: [TTSegmentedControlTitle] {
        ["Cats", "Dogs", "Rodents"].map { title in
            TTSegmentedControlTitle(
                text: title,
                defaultColor: "1F2937".color,
                defaultFont: .SFProText.medium(size: 14),
                selectedColor: .white,
                selectedFont: .SFProText.medium(size: 14)
            )
        }
    }
    
    private var firstSegemntedControl: some View {
        let innerShadow = TTSegmentedControlShadow(
            color: "D1D5DB".color,
            offset: CGSize(width: 0, height: 3),
            innerOffset: .init(width: 0, height: -100),
            opacity: 1,
            radius: 4
        )
        
        return TTSwiftUISegmentedControl(titles: firstSegmentControlTitles)
            .selectionViewColorType(.color(value:"F59E0B".color))
            .bounceAnimationOptions( .init())
            .cornerRadius( .constant(value: 8))
            .selectionViewPadding(.init(width: 4, height: 4))
            .containerViewInnerShadow(innerShadow)
            .frame(height: 48)
    }
}

extension SwiftUIView {
    private var secondSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "SHARP CORNERS & SHADOW", description: "Equal segments")
            secondSegmentedControl
        }
    }
    
    private var secondSegmentControlTitles: [TTSegmentedControlTitle] {
        ["Breakfast", "Lunch", "Dinner"].map { title in
            TTSegmentedControlTitle(
                text: title,
                defaultColor: "1F2937".color,
                defaultFont: .SFProText.medium(size: 14),
                selectedColor: .white,
                selectedFont: .SFProText.medium(size: 14)
            )
        }
    }
    
    private var secondSegmentedControl: some View {
        let shadow = TTSegmentedControlShadow(
            color: .black.withAlphaComponent(0.2),
            offset: CGSize(width: 0, height: 2),
            opacity: 1,
            radius: 4
        )
        return HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: secondSegmentControlTitles)
                .titleDistribution(.fillEqually)
                .selectionViewFillType(.fillText)
                .bounceAnimationOptions(nil)
                .selectionViewColorType(.color(value: "14B8A6".color))
                .selectionViewShadow(shadow)
                .cornerRadius(.none)
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var thirdSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "GRADIENT & SHADOW", description: "Various colors, sizes, fonts")
            thirdSegmentedControl
        }
    }
    
    private var thirdSegmentedControlTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            text: "Men",
            defaultColor: "111827".color,
            defaultFont: .PTSerif.bold(size: 18),
            selectedColor: .white,
            selectedFont: .PTSerif.bold(size: 18)
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Women",
            defaultColor: "7C3AED".color,
            defaultFont: .Pacifico.regular(size: 20),
            selectedColor: "FF95E8".color,
            selectedFont: .Pacifico.regular(size: 20)
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Kids",
            defaultColor: "2563EB".color,
            defaultFont: .SigmarOne.regular(size: 18),
            selectedColor: "99F6E4".color,
            selectedFont: .SigmarOne.regular(size: 18)
        )
        
        return [title1, title2, title3]
    }
    
    private var thirdSegmentedControl: some View {
        let gradient = TTSegmentedControlGradient(
            startPoint: .init(x: 0.5, y: 0),
            endPoint: .init(x: 0.5, y: 1),
            colors: ["3B82F6".color, "6514EF".color]
        )
        let shadow = TTSegmentedControlShadow(
            color: .black.withAlphaComponent(0.4),
            offset: CGSize(width: 0, height: 4),
            opacity: 1,
            radius: 4
        )
        return HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: thirdSegmentedControlTitles)
                .selectionViewColorType(.colorWithGradient(color: "FFCC00".color, gradient: gradient))
                .selectionViewShadow(shadow)
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var fourthSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "TEXT & IMAGE", description: "Images on top")
            fourthSegmentedControl
        }
    }
    
    private var fourthSegmentedControlTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            text: "Account",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "account_normal"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "account_selected"),
            imagePosition: .top,
            spaceBetweenTextAndImage: 4
            
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Settings",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "settings_normal"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "settings_selected"),
            imagePosition: .top,
            spaceBetweenTextAndImage: 4
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Billing",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "billling_normal"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "billling_selected"),
            imagePosition: .top,
            spaceBetweenTextAndImage: 4
        )
        
        return [title1, title2, title3]
    }
    
    private var fourthSegmentedControl: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: fourthSegmentedControlTitles)
                .selectionViewColorType(.color(value: "7C3AED".color))
                .bounceAnimationOptions( .init())
                .cornerRadius(.constant(value: 8))
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var switchViewSection: some View {
        VStack(spacing: 10) {
            header(title: "SWITCH", description: "")
                .padding(.horizontal, 20)
            
            HStack(spacing: .zero) {
                Text("Appearance")
                    .font(.SFProText.medium(size: 14))
                    .foregroundColor(Color("1F2937".color))
                Spacer(minLength: .zero)
                switchView
            }
            .frame(height: 60)
            .padding(.horizontal, 24)
            .background(Color.white)
        }
    }
    
    private var switchTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            defaultImage: UIImage(named: "switch_option_1_default"),
            selectedImage: UIImage(named: "switch_option_1_selected")
        )
        
        let title2 = TTSegmentedControlTitle(
            defaultImage: UIImage(named: "switch_option_2_default"),
            selectedImage: UIImage(named: "switch_option_2_selected")
        )
        return [title1, title2]
    }
    
    private var switchView: some View {
        let shadow = TTSegmentedControlShadow(
            color: .black.withAlphaComponent(0.2),
            offset: CGSize(width: 0, height: 4),
            opacity: 1,
            radius: 4
        )
        
        return TTSwiftUISegmentedControl(titles: switchTitles)
            .containerColorType(.color(value: "F3F4F6".color))
            .selectionViewColorType(.color(value: .white))
            .selectionViewShadow(shadow)
            .bounceAnimationOptions(.init())
            .selectionViewPadding(.init(width: 2, height: 2))
            .frame(width: 92, height: 36)
    }
}

extension SwiftUIView {
    private func header(title: String, description: String) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color("9CA3AF".color))
            
            Spacer(minLength: .zero)
            
            Text(description)
                .font(Font.system(size: 12, weight: .regular))
                .foregroundColor(Color("9CA3AF".color))
        }
    }
}

private extension String {
    var color: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
