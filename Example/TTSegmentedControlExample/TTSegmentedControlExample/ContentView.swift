//
//  SwiftUIView.swift
//  SegmentedControl
//
//  Created by Igor Dumitru on 01.02.2023.
//

import SwiftUI
import TTSegmentedControl

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            example1Section
            example2Section
            example3Section
            example4Section
            switchViewSection
        }
        .padding(.horizontal, 24)
    }
}

extension ContentView {
    private var example1Section: some View {
        VStack(spacing: 10) {
            header(title: "Fully rounded, gradient buttons")
            Example1View()
        }
    }
    
    private var example2Section: some View {
        VStack(spacing: 10) {
            header(title: "Round, text only - gradient - outline")
            Example2View()
        }
    }
    
    private var example3Section: some View {
        VStack(spacing: 10) {
            header(title: "Round, Icons + Text")
            Example3View()
        }
    }
    
    private var example4Section: some View {
        VStack(spacing: 10) {
            header(title: "Fully rounded, inner shadow")
            Example4View()
        }
    }
    
    private var switchViewSection: some View {
        VStack(spacing: 10) {
            header(title: "Switch")
            SwitchView()
                .frame(height: 60)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension ContentView {
    private func header(title: String) -> some View {
        HStack(spacing: .zero) {
            Text(title.uppercased())
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color("9CA3AF".color))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
