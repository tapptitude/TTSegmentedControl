//
//  TitleComponentFrameListBuilderTests.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 07.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class TitleComponentFrameListBuilderTests: XCTestCase {
    func testBuilder() {
        // Given
        let viewBounds = CGRect(x: 0, y: 0, width: 200, height: 40)
        let textSizes: [CGSize] = [.init(width: 20, height: 13)]
        let imageSizes: [CGSize] = [.zero]
        let spaceBetweenTitleItems: [CGFloat] = [.zero]
        let imagePositions: [TTSegmentedControlTitle.ImagePosition] = [.right]
        let padding: CGSize = .init(width: 2, height: 2)
        let titleDistribution: TTSegmentedControl.TitleDistribution = .equalSpacing
        
        let builder = TitleComponentFrameListBuilder(
            viewBounds: viewBounds,
            cornerRadius: .none,
            textsSizes: textSizes,
            imagesSizes: imageSizes,
            spaceBetweenTitleItems: spaceBetweenTitleItems,
            imagePositions: imagePositions,
            padding: padding,
            titleDistribution: titleDistribution
        )
        
        let checkTextFrame = CGRect(x: 90, y: 13.5, width: 20, height: 13)
        let checkImageFrame = CGRect(x: 110, y: 20, width: 0, height: 0)
        let checkTotalFrame = CGRect(x: 90, y: 0, width: 20, height: 40)
        
        // When
        let titleComponent = builder.build().first
        
        // Then
        XCTAssertNotNil(titleComponent)
        XCTAssertEqual(titleComponent?.text, checkTextFrame)
        XCTAssertEqual(titleComponent?.total, checkTotalFrame)
        XCTAssertEqual(titleComponent?.image, checkImageFrame)
    }
}

