//: Playground - noun: a place where people can play
import UIKit
import Foundation
import PlaygroundSupport


let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 667))
mainView.backgroundColor = UIColor.white

var segmentedC5: TTSegmentedControl = TTSegmentedControl()
var segmentedC4: TTSegmentedControl = TTSegmentedControl()
var segmentedC3: TTSegmentedControl = TTSegmentedControl()
var segmentedC2: TTSegmentedControl = TTSegmentedControl()
var segmentedC1: TTSegmentedControl = TTSegmentedControl()

segmentedC1.frame = CGRect(x: 14, y: 73, width: 322, height: 76)
segmentedC2.frame = CGRect(x: 14, y: 186, width: 322, height: 47)
segmentedC3.frame = CGRect(x: 14, y: 299, width: 322, height: 47)
segmentedC4.frame = CGRect(x: 14, y: 417, width: 133, height: 35)
segmentedC5.frame = CGRect(x: 14, y: 500, width: 322, height: 47)

//SegmentedControl 1

segmentedC1.itemTitles = ["men","women","kids"]
segmentedC1.allowChangeThumbWidth = false
segmentedC1.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
segmentedC1.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.01))
segmentedC1.cornerRadius = 5
segmentedC1.useVerticalGradient = false
segmentedC1.useHorizontalGradient = true
segmentedC1.useShadow = false
segmentedC1.thumbColor = TTSegmentedControl.UIColorFromRGB(0xD9D72B)


//SegmentedControl 2

segmentedC2.itemTitles = ["gas","diesel","electric"]
segmentedC2.allowChangeThumbWidth = false
segmentedC2.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
segmentedC2.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.01))
segmentedC2.cornerRadius = 0
segmentedC2.useShadow = false
segmentedC2.useVerticalGradient = true
segmentedC1.useHorizontalGradient = false
segmentedC2.thumbGradientColors = [ TTSegmentedControl.UIColorFromRGB(0xFE2C5A), TTSegmentedControl.UIColorFromRGB(0xF10EAE)]


//SegmentedControl 3

segmentedC3.itemTitles = ["XS","S","M","L","XL"]
segmentedC3.allowChangeThumbWidth = false
segmentedC3.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
segmentedC3.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.01))
segmentedC3.useVerticalGradient = true
segmentedC3.useHorizontalGradient = false
segmentedC3.useShadow = true
segmentedC3.thumbShadowColor = TTSegmentedControl.UIColorFromRGB(0x22C6E7)
segmentedC3.thumbGradientColors = [ TTSegmentedControl.UIColorFromRGB(0x25D0EC), TTSegmentedControl.UIColorFromRGB(0x1EA3D8)]
segmentedC3.didSelectItemWith = { index, title in
    print(index)
}


//SegmentedControl 4

segmentedC4.itemTitles = ["OFF","ON"]
segmentedC4.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
segmentedC4.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.01))
segmentedC4.useVerticalGradient = false
segmentedC4.useHorizontalGradient = false
segmentedC4.thumbColor = TTSegmentedControl.UIColorFromRGB(0x1FDB58)
segmentedC4.useShadow = true
segmentedC4.thumbShadowColor = TTSegmentedControl.UIColorFromRGB(0x56D37C)
segmentedC4.allowChangeThumbWidth = false


//SegmentedControl 5

segmentedC5.itemTitles = ["XS","S","M","L","XL"]
segmentedC5.allowChangeThumbWidth = false
segmentedC5.selectedTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
segmentedC5.defaultTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.01))
segmentedC5.useVerticalGradient = false
segmentedC5.useHorizontalGradient = true
segmentedC5.useShadow = true
segmentedC5.thumbShadowColor = TTSegmentedControl.UIColorFromRGB(0x22C6E7)
segmentedC5.thumbGradientColors = [ TTSegmentedControl.UIColorFromRGB(0x25D0EC), TTSegmentedControl.UIColorFromRGB(0x1EA3D8)]
segmentedC5.didSelectItemWith = { index, title in
    print(index)
}

mainView.addSubview(segmentedC1)
mainView.addSubview(segmentedC2)
mainView.addSubview(segmentedC3)
mainView.addSubview(segmentedC4)
mainView.addSubview(segmentedC5)

PlaygroundPage.current.liveView = mainView













