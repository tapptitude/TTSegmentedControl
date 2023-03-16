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
                    fifthSegmentedControlSection
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
        ["Men", "Women", "Kids"].map { title in
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
        TTSwiftUISegmentedControl(titles: firstSegmentControlTitles)
            .selectionViewColorType(.color(value:"2563EB".color))
            .bounceAnimationOptions( .init())
            .cornerRadius( .constant(value: 8))
            .selectionViewPadding(.init(width: 4, height: 4))
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
    
    private var secondSegmentedControl: some View {
        let shadow = TTSegmentedControlShadow(
            color: .black.withAlphaComponent(0.4),
            offset: CGSize(width: 0, height: 4),
            opacity: 1,
            radius: 4
        )
        return HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: firstSegmentControlTitles)
                .titleDistribution(.fillEqually)
                .selectionViewFillType(.fillText)
                .bounceAnimationOptions(nil)
                .selectionViewColorType(.color(value: "2563EB".color))
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
            defaultColor: "2563EB".color,
            defaultFont: .PTSerif.bold(size: 18),
            selectedColor: "FCD34D".color,
            selectedFont: .PTSerif.bold(size: 18)
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Women",
            defaultColor: "7C3AED".color,
            defaultFont: .BeauRivage.regular(size: 24),
            selectedColor: "FCD34D".color,
            selectedFont: .BeauRivage.regular(size: 24)
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Kids",
            defaultColor: "2563EB".color,
            defaultFont: .DeliusSwashCaps.regular(size: 17),
            selectedColor: "FCD34D".color,
            selectedFont: .DeliusSwashCaps.regular(size: 17)
        )
        
        return [title1, title2, title3]
    }
    
    private var thirdSegmentedControl: some View {
        let gradient = TTSegmentedControlGradient(
            startPoint: .init(x: 0.5, y: 0),
            endPoint: .init(x: 0.5, y: 1),
            colors: ["A114B8".color, "7C3AED".color, "3B82F6".color]
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
            header(title: "TEXT & IMAGE", description: "Images on the left")
            fourthSegmentedControl
        }
    }
    
    private var fourthSegmentedControlTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            text: "Account",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "account-2"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "account-2"),
            imagePosition: .left,
            spaceBetweenTextAndImage: 6
            
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Settings",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "settings_normal"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "settings-2"),
            imagePosition: .left,
            spaceBetweenTextAndImage: 6
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Billing",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "billling_normal"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "billing-2"),
            imagePosition: .left,
            spaceBetweenTextAndImage: 6
        )
        
        return [title1, title2, title3]
    }
    
    private var fourthSegmentedControl: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: fourthSegmentedControlTitles)
                .selectionViewColorType(.color(value: "7C3AED".color))
                .cornerRadius(.constant(value: 8))
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var fifthSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "TEXT & IMAGE", description: "Images on right, top, bottom")
            fifthSegmentedControl
        }
    }
    
    private var fifthSegmentedControlTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            text: "Account",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "account-2"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "account-2"),
            imagePosition: .right,
            spaceBetweenTextAndImage: 7
            
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Settings",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "settings-2"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "settings-2"),
            imagePosition: .top,
            spaceBetweenTextAndImage: 6
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Billing",
            defaultColor: "1F2937".color,
            defaultFont: .SFProText.medium(size: 14),
            defaultImage: UIImage(named: "billing-2"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "billing-2"),
            imagePosition: .bottom,
            spaceBetweenTextAndImage: 6
        )
        
        return [title1, title2, title3]
    }
    
    private var fifthSegmentedControl: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: fifthSegmentedControlTitles)
                .selectionViewColorType(.color(value: "0D9488".color))
                .bounceAnimationOptions(.init())
                .cornerRadius(.constant(value: 8))
                .selectionViewPadding(.zero)
                .selectionViewFillType(.fillText)
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
                Text("Notifications")
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
            text: "OFF",
            defaultColor: "9CA3AF".color,
            defaultFont: .SFProText.medium(size: 12),
            selectedColor: "9CA3AF".color,
            selectedFont: .SFProText.medium(size: 12)
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "ON",
            defaultColor: "9CA3AF".color,
            defaultFont: .SFProText.medium(size: 12),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 12)
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
            .containerColorType(.color(value: "E5E7EB".color))
            .selectionViewColorType(.color(value: .white))
            .switchSecondSelectionViewColorType(.color(value: "0D9488".color))
            .selectionViewShadow(shadow)
            .bounceAnimationOptions(.init())
            .selectionViewPadding(.init(width: 2, height: 2))
            .frame(width: 84, height: 32)
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
