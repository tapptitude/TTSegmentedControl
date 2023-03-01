//
//  SwiftUIView.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import SwiftUI

struct SwiftUIView: View {
    
    var body: some View {
        ZStack {
            if #available(iOS 14.0, *) {
                Color("EFEEF3".color).ignoresSafeArea()
            } else {
                Color("EFEEF3".color)
            }
       
            VStack(spacing: 30) {
                smallBorderSegmentViewSection
                fillEquallySegmentViewSection
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
            .selectionViewColor("00C7BE".color)
            .selectionViewShadow(.init())
            .bounceAnimationOptions(.init())
            .frame(width: 100, height: 34)
    }
}

extension SwiftUIView {
    private var smallBorderSegmentViewTitles: [TTSegmentedControlTitle] {
        ["Men", "Women", "Kids"].map({TTSegmentedControlTitle(text: $0)})
    }
    
    private var smallBorderSegmentViewSection: some View {
        VStack(spacing: 10) {
            header(title: "ROUNDED EDGES", description: "Equal space between titles")
            smallBorderSegmentView
        }
        .padding(.horizontal, 20)
    }
    
    private var smallBorderSegmentView: some View {
        TTSwiftUISegmentedControl(titles: smallBorderSegmentViewTitles)
            .selectionViewColor( "D9CC23".color)
            .bounceAnimationOptions( .init())
            .cornerRadius( .constant(value: 5))
            .frame(height: 45)
    }
}

extension SwiftUIView {
    private var fillEquallySegmentViewSection: some View {
        VStack(spacing: 10) {
            header(title: "STRAIGHT EDGES", description: "Equal segments")
            fillEquallySegmentView
        }
        .padding(.horizontal, 20)
    }
    
    private var fillEquallySegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: smallBorderSegmentViewTitles)
                .titleDistribution(.fillEqually)
                .selectionViewColor("D9CC23".color)
                .selectionViewShadow(.init())
                .cornerRadius(.none)
                .frame(height: 45)
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
    
    
    private var differentColorTitleSegmentViewTitles: [TTSegmentedControlTitle] {
        let title1 = TTSegmentedControlTitle(
            text: "Men",
            defaultColor: .black,
            selectedColor: .red,
            selectedFont: .boldSystemFont(ofSize: 16)
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Women",
            defaultColor: .green,
            selectedColor: .blue
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Kids",
            defaultColor: .red,
            selectedColor: .yellow,
            selectedFont: .boldSystemFont(ofSize: 18)
        )
        
        return [title1, title2, title3]
    }
    
    private var differentColorTitleSegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: differentColorTitleSegmentViewTitles)
                .containerGradient(.init(startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1), colors: [.white, .gray.withAlphaComponent(0.5)]))
                .selectionViewColor("FFCC00".color)
                .selectionViewGradient(.init(startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1), colors: ["FF2D55".color, "FFC555".color]))
                .selectionViewShadow(.init())
                .frame(height: 55)
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
            text: "Facebook",
            defaultColor: .black,
            defaultImage: UIImage(named: "facebook_unselected"),
            selectedColor: "39549D".color,
            selectedImage: UIImage(named: "facebook_selected"),
            imageSize: CGSize(width: 16, height: 16)
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Youtube",
            defaultColor: .black,
            defaultImage: UIImage(named: "youtube_unselected"),
            selectedColor: "FF0000".color,
            selectedImage: UIImage(named: "youtube_selected"),
            imageSize: CGSize(width: 16, height: 16)
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Twitter",
            defaultColor: .black,
            defaultImage: UIImage(named: "twitter_unselected"),
            selectedColor: "65BBF2".color,
            selectedImage: UIImage(named: "twitter_selected"),
            imageSize: CGSize(width: 16, height: 16)
        )
        
        return [title1, title2, title3]
    }
    
    private var titlesWithImagesSegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: titlesWithImagesSegmentViewTitles)
                .selectionViewColor("7BEA73".color)
                .selectionViewShadow(.init())
                .cornerRadius(.constant(value: 5))
                .frame(height: 45)
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
            text: "Facebook",
            defaultColor: .black,
            defaultImage: UIImage(named: "facebook_unselected"),
            selectedColor: "39549D".color,
            selectedImage: UIImage(named: "facebook_selected"),
            imageSize: CGSize(width: 16, height: 16),
            imagePosition: .left
            
        )
        
        let title2 = TTSegmentedControlTitle(
            text: "Youtube",
            defaultColor: .black,
            defaultImage: UIImage(named: "youtube_unselected"),
            selectedColor: "FF0000".color,
            selectedImage: UIImage(named: "youtube_selected"),
            imageSize: CGSize(width: 16, height: 16),
            imagePosition: .bottom
        )
        
        let title3 = TTSegmentedControlTitle(
            text: "Twitter",
            defaultColor: .black,
            defaultImage: UIImage(named: "twitter_unselected"),
            selectedColor: "65BBF2".color,
            selectedImage: UIImage(named: "twitter_selected"),
            imageSize: CGSize(width: 16, height: 16),
            imagePosition: .top
        )
        
        return [title1, title2, title3]
    }
    
    private var differentImagePositionSegmentView: some View {
        HStack(spacing: .zero) {
            TTSwiftUISegmentedControl(titles: differentImagePositionSegmentViewTitles)
                .selectionViewColor("7BEA73".color)
                .selectionViewShadow(.init())
                .bounceAnimationOptions(.init())
                .frame(height: 55)
        }
    }
}

extension SwiftUIView {
    private func header(title: String, description: String) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(Font.system(size: 16, weight: .semibold))
                .foregroundColor(Color("99989D".color))
            
            Spacer(minLength: .zero)
            
            Text(description)
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(Color("99989D".color))
        }
    }
}
