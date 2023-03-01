//
//  TTSegmentedControlTitleAdditionTests.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 08.02.2023.
//

import XCTest
@testable import TTSegmentedControl

final class TTSegmentedControlTitleAdditionTests: XCTestCase {

    func testAvailableDefaultAttributedTextWithNoText() {
        // Given
        let title = TTSegmentedControlTitle.init()
        
        // When
        let attributedText = title.availableDefaultAttributedText
        
        // Then
        XCTAssertTrue(attributedText.string.isEmpty)
    }
    
    func testAvailableDefaultAttributedTextWithString() {
        // Given
        let title = TTSegmentedControlTitle.init(text: "text")
        
        // When
        let attributedText = title.availableDefaultAttributedText
        
        // Then
        let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        let color = attributes[.foregroundColor] as! UIColor
        let font = attributes[.font] as! UIFont
        
        XCTAssertEqual(title.text, attributedText.string)
        XCTAssertEqual(title.defaultColor, color)
        XCTAssertEqual(title.defaultFont, font)
    }
    
    func testAvailableDefaultAttributedTextWithAttributedString() {
        // Given
        let initialAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        let initialAattributedString = NSAttributedString(string: "text", attributes: initialAttributes)
        
        let title = TTSegmentedControlTitle.init(defaultAttributedText: initialAattributedString)
        
        // When
        let attributedText = title.availableDefaultAttributedText
        
        // Then
        let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        let color = attributes[.foregroundColor] as! UIColor
        let font = attributes[.font] as! UIFont
        
        XCTAssertEqual(attributedText.string, initialAattributedString.string)
        XCTAssertEqual(color, .black)
        XCTAssertEqual(font, UIFont.systemFont(ofSize: 15))
    }
    
    func testAvailableSelectedAttributedTextWithNoText() {
        // Given
        let title = TTSegmentedControlTitle.init()
        
        // When
        let attributedText = title.availableSelectedAttributedText
        
        // Then
        XCTAssertTrue(attributedText.string.isEmpty)
    }
    
    func testsAailableSelectedAttributedTextWithText() {
        // Given
        let title = TTSegmentedControlTitle.init(text: "text")
        
        // When
        let attributedText = title.availableSelectedAttributedText
        
        // Then
        let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        let color = attributes[.foregroundColor] as! UIColor
        let font = attributes[.font] as! UIFont
        
        XCTAssertEqual(title.text, attributedText.string)
        XCTAssertEqual(title.selectedColor, color)
        XCTAssertEqual(title.selectedFont, font)
    }
    
    func testaAailableSelectedAttributedTextWithAttributedString() {
        // Given
        let initialAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        let initialAattributedString = NSAttributedString(string: "text", attributes: initialAttributes)
        
        let title = TTSegmentedControlTitle.init(selectedAttributedText: initialAattributedString)
        
        // When
        let attributedText = title.availableSelectedAttributedText
        
        // Then
        let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        let color = attributes[.foregroundColor] as! UIColor
        let font = attributes[.font] as! UIFont
        
        XCTAssertEqual(attributedText.string, initialAattributedString.string)
        XCTAssertEqual(color, .black)
        XCTAssertEqual(font, UIFont.systemFont(ofSize: 15))
    }
    
    func testAvailableImageSizeWithImageSize() {
        // Given
        let initialImageSize = CGSize(width: 10, height: 10)
        let title = TTSegmentedControlTitle.init(text: "text", imageSize: initialImageSize)
        
        // When
        let imageSize = title.availableImageSize
        
        // Then
        XCTAssertEqual(imageSize, initialImageSize)
    }
    
    func testAvailableImageSizeWithNoImageNameAndNoImageSize() {
        // Given
        let title = TTSegmentedControlTitle.init(text: "text")
        
        // When
        let imageSize = title.availableImageSize
        
        // Then
        XCTAssertEqual(imageSize, .zero)
    }
    
    func testAvailableImageSizeWithNoImageAndNoImageSize() {
        // Given
    
        let title = TTSegmentedControlTitle.init(
            text: "text"
        )
        
        // When
        let imageSize = title.availableImageSize
        
        // Then
        XCTAssertEqual(imageSize, .zero)
    }
    
    func testAvailableImageSizeForImageWithoutImageSize() {
        // Given
        let initialImageSize = UIImage(named: "youtube_selected")!.size
        let title = TTSegmentedControlTitle.init(
            text: "text",
            defaultImage: UIImage(named: "youtube_selected"),
            selectedImage: UIImage(named: "youtube_selected")
        )
        
        // When
        let imageSize = title.availableImageSize
        
        // Then
        XCTAssertEqual(imageSize, initialImageSize)
    }
}
