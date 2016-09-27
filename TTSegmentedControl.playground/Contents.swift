//: Playground - noun: a place where people can play

import UIKit
import Foundation
import XCPlayground


//: Playground - noun: a place where people can play

import UIKit
import Foundation
import XCPlayground


func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}




let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 667))
mainView.backgroundColor = UIColor.white



var segmentedC4: TTSegmentedControl = TTSegmentedControl()
var segmentedC3: TTSegmentedControl = TTSegmentedControl()
var segmentedC2: TTSegmentedControl = TTSegmentedControl()
var segmentedC1: TTSegmentedControl = TTSegmentedControl()

segmentedC1.frame = CGRect(x: 14, y: 73, width: 346, height: 76)
segmentedC2.frame = CGRect(x: 14, y: 186, width: 346, height: 47)
segmentedC3.frame = CGRect(x: 14, y: 299, width: 346, height: 47)
segmentedC4.frame = CGRect(x: 218, y: 417, width: 133, height: 35)



//SegmentedControl 1

segmentedC1.itemTitles = ["men","women","kids"]
segmentedC1.allowChangeThumbWidth = false
segmentedC1.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: 0.3)
segmentedC1.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: 0.01)
segmentedC1.cornerRadius = 5
segmentedC1.useGradient = false
segmentedC1.useShadow = false
segmentedC1.thumbColor = UIColorFromRGB(0xD9D72B)

//SegmentedControl 2

segmentedC2.itemTitles = ["gas","diesel","electric"]
segmentedC2.allowChangeThumbWidth = false
segmentedC2.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: 0.3)
segmentedC2.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: 0.01)
segmentedC2.cornerRadius = 0
segmentedC2.useShadow = false
segmentedC2.useGradient = true
segmentedC2.thumbGradientColors = [ UIColorFromRGB(0xFE2C5A),UIColorFromRGB(0xF10EAE)]

//SegmentedControl 3

segmentedC3.itemTitles = ["XS","S","M","L","XL"]
segmentedC3.allowChangeThumbWidth = false
segmentedC3.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: 0.3)
segmentedC3.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: 0.01)
segmentedC3.useGradient = true
segmentedC3.useShadow = true
segmentedC3.thumbShadowColor = UIColorFromRGB(0x22C6E7)
segmentedC3.thumbGradientColors = [ UIColorFromRGB(0x25D0EC), UIColorFromRGB(0x1EA3D8)]

//SegmentedControl 4

segmentedC4.itemTitles = ["OFF","ON"]
segmentedC4.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: 0.3)
segmentedC4.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: 0.01)
segmentedC4.useGradient = false
segmentedC4.thumbColor = UIColorFromRGB(0x1FDB58)
segmentedC4.useShadow = true
segmentedC4.thumbShadowColor = UIColorFromRGB(0x56D37C)
segmentedC4.allowChangeThumbWidth = false

mainView.addSubview(segmentedC1)
mainView.addSubview(segmentedC2)
mainView.addSubview(segmentedC3)
mainView.addSubview(segmentedC4)


XCPlaygroundPage.currentPage.liveView = mainView













