//: Playground - noun: a place where people can play

import UIKit
import Foundation
import XCPlayground


func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

var options = TTSegmentedControl.Options()

options.defaultTextColor = UIColor.whiteColor()
options.selectedTextColor = UIColor.blackColor()
options.thumbColor = UIColor.whiteColor()
options.thumbGradientColors = []
options.useShadow = true
options.containerBackgroundColor = UIColorFromRGB(0x3DC120)
options.cornerRadius = 5

let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 667))
mainView.backgroundColor = UIColor.whiteColor()
let segmentControl = TTSegmentedControl()

segmentControl.options = options
segmentControl.frame = CGRect(x: 50, y: 200, width: 100, height: 50)



segmentControl.allowChangeThumbWidth = false
segmentControl.options.padding.width = 30
segmentControl.itemTitles = ["Item1", "Item2", "Item3", "Item4"]
segmentControl.didSelectItemWith = { (index, title) -> () in
    print("Selected item \(index)")
}
mainView.addSubview(segmentControl)

XCPlaygroundPage.currentPage.liveView = mainView






