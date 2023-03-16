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
       
            VStack(spacing: 30) {
                firstSegmentedControlSection
                secondSegmentedControlSection
                differentColorTitleSegmentViewSection
                titlesWithImagesSegmentViewSection
                differentImagePositionSegmentViewSection
                switchViewSection
            }
        }
    }
}

extension SwiftUIView {
    private var switchTitles: [TTSegmentedControlTitle] {
        ["Off", "On"].map({TTSegmentedControlTitle(text: $0)})
    }
    
    private var switchViewSection: some View {
        VStack(spacing: 10) {
            header(title: "SWITCH", description: "")
                .padding(.horizontal, 20)
            
            HStack(spacing: .zero) {
                Text("Notifications")
                    .font(Font.system(size: 16, weight: .regular))
                Spacer(minLength: .zero)
                switchView
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .background(Color.white)
            
        }
    }
    
    private var switchView: some View {
        TTSwiftUISegmentedControl(titles: switchTitles)
            .containerBackgroundColor("EFEEF3".color)
            .selectionViewColor("0D9488".color)
            .selectionViewShadow(.init())
            .bounceAnimationOptions(.init())
            .frame(width: 100, height: 34)
    }
}

extension SwiftUIView {
    private var firstSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "ROUNDED EDGES", description: "Equal space between titles")
            firstSegemntedControl
        }
        .padding(.horizontal, 20)
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
            .selectionViewColor( "2563EB".color)
            .bounceAnimationOptions( .init())
            .cornerRadius( .constant(value: 8))
            .selectionViewPadding(.init(width: 4, height: 4))
            .frame(height: 48)
    }
}

extension SwiftUIView {
    private var secondSegmentedControlSection: some View {
        VStack(spacing: 10) {
            header(title: "STRAIGHT EDGES", description: "Equal segments")
            secondSegmentedControl
        }
        .padding(.horizontal, 20)
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
                .selectionViewColor("2563EB".color)
                .selectionViewShadow(shadow)
                .cornerRadius(.none)
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var differentColorTitleSegmentViewSection: some View {
        VStack(spacing: 10) {
            header(title: "GRADIENT & SHADOW", description: "Colored titles")
            differentColorTitleSegmentView
        }
        .padding(.horizontal, 20)
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
    
    private var differentColorTitleSegmentView: some View {
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
                .selectionViewColor("FFCC00".color)
                .selectionViewGradient(gradient)
                .selectionViewShadow(shadow)
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var titlesWithImagesSegmentViewSection: some View {
        VStack(spacing: 10) {
            header(title: "TEXT & IMAGE", description: "Images right sided")
            titlesWithImagesSegmentView
        }
        .padding(.horizontal, 20)
    }
    
    private var titlesWithImagesSegmentViewTitles: [TTSegmentedControlTitle] {
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
            defaultImage: UIImage(named: "settings-2"),
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
            defaultImage: UIImage(named: "billing-2"),
            selectedColor: .white,
            selectedFont: .SFProText.medium(size: 14),
            selectedImage: UIImage(named: "billing-2"),
            imagePosition: .left,
            spaceBetweenTextAndImage: 6
        )
        
        return [title1, title2, title3]
    }
    
    private var titlesWithImagesSegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: titlesWithImagesSegmentViewTitles)
                .selectionViewColor("7C3AED".color)
                .cornerRadius(.constant(value: 8))
                .selectionViewPadding(.zero)
                .frame(height: 48)
        }
    }
}

extension SwiftUIView {
    private var differentImagePositionSegmentViewSection: some View {
        VStack(spacing: 10) {
            header(title: "TEXT & IMAGE", description: "Images on left, top, bottom")
            differentImagePositionSegmentView
        }
        .padding(.horizontal, 20)
    }
    
    private var differentImagePositionSegmentViewTitles: [TTSegmentedControlTitle] {
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
    
    private var differentImagePositionSegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: differentImagePositionSegmentViewTitles)
                .selectionViewColor("0D9488".color)
                .bounceAnimationOptions(.init())
                .cornerRadius(.constant(value: 8))
                .selectionViewPadding(.zero)
                .selectionViewFillType(.fillText)
                .frame(height: 48)
        }
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
