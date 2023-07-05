//
//  MinSizeBuilderTests.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class MinSizeBuilderTests: XCTestCase {
    private let textSizes: [CGSize] = [
        .init(width: 20, height: 13),
        .init(width: 20, height: 13)
    ]
    private let imageSizes: [CGSize] = [.zero, .zero]
    private let spaceBetweenTitleItems: [CGFloat] = [.zero, .zero]
    private let imagePositions: [TTSegmentedControlTitle.ImagePosition] = [.right, .right]
    private let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
    private let padding: CGSize = .init(width: 2, height: 2)
    private let titleDistribution: TTSegmentedControl.TitleDistribution = .equalSpacing
    
    func testBuilder() {
        // Given
        let checkSize = CGSize(width: 80, height: 17)
        
        let builder = MinSizeBuilder(
            defaultTextsSizes: textSizes,
            selectedTextsSizes: textSizes,
            imagesSizes: imageSizes,
            spaceBetweenTitleItems: spaceBetweenTitleItems,
            imagePositions: imagePositions,
            currentBounds: viewBounds.size,
            cornerRadius: .none,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let minSize = builder.build()
        
        // Then
        XCTAssertEqual(minSize, checkSize)
    }
    
    func testWhenNoTitlesAvailableAndEqualSpacingDistribution() {
        // Given
        let checkSize = CGSize(width: 4, height: 4)
        
        let builder = MinSizeBuilder(
            defaultTextsSizes: [],
            selectedTextsSizes: [],
            imagesSizes: [],
            spaceBetweenTitleItems: [],
            imagePositions: [],
            currentBounds: viewBounds.size,
            cornerRadius: .none,
            padding: padding,
            titleDistribution: .equalSpacing
        )
        
        // When
        let minSize = builder.build()
        
        // Then
        XCTAssertEqual(minSize, checkSize)
    } 
    
    func testWhenNoTitlesAvailableAndFillEqually() {
        // Given
        let checkSize = CGSize(width: 4, height: 4)
        
        let builder = MinSizeBuilder(
            defaultTextsSizes: [],
            selectedTextsSizes: [],
            imagesSizes: [],
            spaceBetweenTitleItems: [],
            imagePositions: [],
            currentBounds: viewBounds.size,
            cornerRadius: .none,
            padding: padding,
            titleDistribution: .fillEqually
        )
        
        // When
        let minSize = builder.build()
        
        // Then
        XCTAssertEqual(minSize, checkSize)
    }
    
    func testWhenImagesAreOnLeftOrRideSide() {
        // Given
        let checkSize = CGSize(width: 80, height: 17)
        let imagePositions: [TTSegmentedControlTitle.ImagePosition] = [.top, .bottom]
        
        let builder = MinSizeBuilder(
            defaultTextsSizes: textSizes,
            selectedTextsSizes: textSizes,
            imagesSizes: imageSizes,
            spaceBetweenTitleItems: spaceBetweenTitleItems,
            imagePositions: imagePositions,
            currentBounds: viewBounds.size,
            cornerRadius: .none,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        // When
        let minSize = builder.build()
        
        // Then
        XCTAssertEqual(minSize, checkSize)
    }
}
