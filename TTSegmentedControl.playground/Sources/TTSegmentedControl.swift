//
//  SegmentController.swift
//  Segment
//
//  Created by Dumitru Igor on 7/28/16.
//  Copyright © 2016 Dumitru Igor. All rights reserved.
//

import UIKit

//v0.1


@IBDesignable
public class TTSegmentedControl: UIView {
    
    //Configure the options to for a custom design
    @IBInspectable public var defaultTextFont: UIFont = UIFont.helveticaNeueLight(12)
    @IBInspectable public var selectedTextFont: UIFont = UIFont.helveticaNeueLight(12)
    @IBInspectable public var defaultTextColor: UIColor = UIColor.blackColor()
    @IBInspectable public var selectedTextColor: UIColor = UIColor.whiteColor()
    @IBInspectable public var useGradient: Bool = true
    
    @IBInspectable public var containerBackgroundColor: UIColor = TTSegmentedControl.UIColorFromRGB(0xF4F4F4)
    @IBInspectable public var thumbColor: UIColor = UIColor.clearColor()
    @IBInspectable public var thumbGradientColors: [UIColor]? = [TTSegmentedControl.UIColorFromRGB(0xFFE900),TTSegmentedControl.UIColorFromRGB(0xFFB400)]
    @IBInspectable public var thumbShadowColor: UIColor = TTSegmentedControl.UIColorFromRGB(0x9B9B9B)
    @IBInspectable public var useShadow:Bool = true
    
    //left and right space between items
    @IBInspectable public var padding: CGSize = CGSize(width: 30, height: 10)
    @IBInspectable public var cornerRadius: CGFloat = -1 // for rounded corner radius use negative value, 0 to disable
    
    public enum DraggingState: Int {
        case None
        case Dragging
        case Cancel
    }
    
    public var itemTitles: [String] = ["Item1", "Item2", "Item3"]
    var attributedDefaultTitles: [NSAttributedString]!
    var attributedSelectedTitles: [NSAttributedString]!
    /*
     Gets called when an item is selected
     */
    public var didSelectItemWith:((index: Int, title: String?) -> ())?
    /*
     Gets called when the dragging state is changed
     */
    public var didChangeDraggingState: ((DraggingState) -> ())?
    
    private(set) var isDragging = false
    public var allowDrag = true
    public var allowChangeThumbWidth = true
    
    private var containerView = UIView()
    private var thumbContainerView = UIView()
    private var thumbView = UIView()
    private var selectedLabelsView = UIView()
    
    private var isConfigurated = false
    private var lastPointX: CGFloat = 0
    private var originalCenter = CGPointZero
    private var lastSelectedViewWidth: CGFloat = 0
    
    
    private let thumbPadding: CGFloat = 2
    
    private let shadowLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    
    private var allowToChangeThumb = false
    private var allowMove = true
    private var selectInitialItem = 0
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if isConfigurated {
            return
        }
        
        isConfigurated = true
        
        configureItemsConent()
        configureViewBounds()
        
        configureContainerView()
        configureItems()
        configureSelectedView()
        configureSelectedLabelsView()
        configureSelectedLabelItems()
        
        containerView.frame = bounds
        containerView.layer.cornerRadius = cornerRadius < 0 ? 0.5 * containerView.frame.size.height : cornerRadius
        selectedLabelsView.frame = containerView.bounds
        
        updateFrameForLables(allItemLabels)
        updateFrameForLables(allSelectedItemLabels)
        updateSelectedViewFrame()
        
        selectItemAt(index:selectInitialItem)
        _ = self.subviews.map({$0.exclusiveTouch = true})
        
    }
    
    //MARK: - Getters
    private var allItemLabels: [UILabel] = []
    private var allSelectedItemLabels: [UILabel] = []
    
    private var sectionWidth: CGFloat {
        return self.frame.size.width / CGFloat(allItemLabels.count)
    }
    
    private var minPoint: CGPoint {
        return allItemLabels[0].center
    }
    
    private var maxPoint: CGPoint {
        return allSelectedItemLabels[allSelectedItemLabels.count - 1].center
    }
    
    private var minContainerWidth: Int {
        return 100
    }
    
    private var isSwitch: Bool {
        return attributedDefaultTitles.count == 2
    }
    
    //MARK: - Helpers
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    private func labelForPoint(point: CGPoint) -> UILabel {
        var pointX = max(point.x, thumbPadding)
        pointX = min(pointX , containerView.frame.size.width - thumbPadding)
        
        let newPoint = CGPointMake(pointX, point.y)
        let allLabels = allItemLabels
        var selectedLabel = UILabel()
        let sectionWidth = self.sectionWidth
        
        let section = trunc(newPoint.x/sectionWidth) + 1
        let sectionCenter = CGPoint(x: (sectionWidth * section) - 0.5 * sectionWidth, y: 0.5 * containerView.frame.size.height)
        for label in allLabels {
            if label.frame.contains(sectionCenter) {
                selectedLabel = label
                return label
            }
        }
        return selectedLabel
    }
    
    private func selectedLabelForPoint(point: CGPoint) -> UILabel {
        let allLabels = allSelectedItemLabels
        var selectedLabel = UILabel()
        let sectionWidth = self.sectionWidth
        
        let section = trunc(point.x/sectionWidth) + 1
        let sectionCenter = CGPoint(x: (sectionWidth * section) - 0.5 * sectionWidth, y: 0.5 * containerView.frame.size.height)
        for label in allLabels {
            if label.frame.contains(sectionCenter) {
                selectedLabel = label
                return label
            }
        }
        return selectedLabel
    }
}

//MARK: - UIConfiguration

extension TTSegmentedControl {
    
    private func configureSelectedView() {
        containerView.addSubview(thumbContainerView)
        thumbContainerView.addSubview(thumbView)
        
        thumbContainerView.backgroundColor = UIColor.clearColor()
        thumbView.backgroundColor = thumbColor
        
        thumbView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight]
        
        if useShadow {
            shadowLayer.shadowColor = thumbShadowColor.CGColor
            shadowLayer.backgroundColor = thumbColor.CGColor
            shadowLayer.shadowOffset = CGSizeMake(0, 1);
            shadowLayer.shadowOpacity = 0.6;
            shadowLayer.shadowRadius = 3
            shadowLayer.masksToBounds = false
            
            thumbContainerView.layer.insertSublayer(shadowLayer, atIndex: 0)
        }
        
        if thumbGradientColors != nil && self.useGradient {
            gradientLayer.startPoint = CGPointMake(0.5, 0.0)
            gradientLayer.endPoint = CGPointMake(0.5, 1.0)
            gradientLayer.backgroundColor = thumbColor.CGColor
            gradientLayer.colors = thumbGradientColors!.map({$0.CGColor})
            thumbView.backgroundColor = UIColor.clearColor()
            thumbView.layer.addSublayer(gradientLayer)
        }
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = containerBackgroundColor
        self.addSubview(containerView)
    }
    
    private func configureSelectedLabelsView() {
        selectedLabelsView.backgroundColor = UIColor.clearColor()
        selectedLabelsView.clipsToBounds = true
        selectedLabelsView.userInteractionEnabled = false
        containerView.addSubview(selectedLabelsView)
    }
    
    
    private func configureItemsConent() {
        var unselectedAttributedStrings = [NSAttributedString]()
        for title in itemTitles {
            let attString = attributedStringForText(title, isSelected: false)
            unselectedAttributedStrings.append(attString)
        }
        attributedDefaultTitles = unselectedAttributedStrings
        
        var attributedStrings = [NSAttributedString]()
        for title in itemTitles {
            let attString = attributedStringForText(title, isSelected: true)
            attributedStrings.append(attString)
        }
        attributedSelectedTitles = attributedStrings
    }
    
    private func configureItems() {
        var i = 1
        for title in attributedDefaultTitles {
            let label = createLabelWithTitle(title, tag: i)
            containerView.addSubview(label)
            allItemLabels.append(label)
            i += 1
        }
    }
    
    private func configureSelectedLabelItems() {
        var i = 1
        for title in attributedSelectedTitles {
            let label = createLabelWithTitle(title, tag: i)
            selectedLabelsView.addSubview(label)
            allSelectedItemLabels.append(label)
            i += 1
        }
    }
    
    private func createLabelWithTitle(attributedTitle: NSAttributedString, tag: Int) -> UILabel {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.attributedText = attributedTitle
        label.tag = tag
        return label
        
    }
    
    private func attributedStringForText(text: String, isSelected: Bool) -> NSAttributedString {
        let textColor = isSelected ? selectedTextColor : defaultTextColor
        let textFont = isSelected ? selectedTextFont : defaultTextFont
        
        let attributes = [NSForegroundColorAttributeName : textColor,
                          NSFontAttributeName : textFont]
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}

extension TTSegmentedControl {
    
    private func updateSelectedViewFrame() {
        thumbContainerView.frame.origin.y = 0
        thumbContainerView.frame.size.height = containerView.frame.size.height
        
        thumbView.frame.size.height = containerView.frame.size.height - 4
        thumbView.layer.cornerRadius = cornerRadius < 0 ? 0.5 * thumbView.frame.size.height : cornerRadius
        thumbView.frame.origin.y = 2
        
        
        shadowLayer.frame = thumbView.bounds
        shadowLayer.cornerRadius = thumbView.layer.cornerRadius
        
        if thumbGradientColors != nil {
            gradientLayer.frame = thumbView.bounds
            gradientLayer.cornerRadius = thumbView.layer.cornerRadius
        }
    }
    
    private func updateFrameForLables(allLabels: [UILabel]) {
        let itemWidth = sectionWidth
        var totalLabelWidth: CGFloat = 0
        for label in allLabels {
            label.sizeToFit()
            totalLabelWidth = totalLabelWidth + label.frame.size.width
        }
        
        var i:CGFloat = 0
        for label in allLabels {
            
            label.frame.origin.y = 0
            label.frame.size.width = min(label.frame.size.width, itemWidth)
            label.frame.size.height = self.frame.size.height
            label.frame.origin.x = (sectionWidth - label.frame.size.width)/2 + i * itemWidth
            i += 1
        }
    }
}

//MARK: - UIResponder Methods

extension TTSegmentedControl {
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        var point = touch?.locationInView(self)
        isDragging = false
        didChangeDraggingState?(.None)
        
        if point == nil {
            return
        }
        if isSwitch && allowToChangeThumb {
            let label = labelForPoint(thumbContainerView.center)
            let otherIndex = allItemLabels.indexOf(label) == 1 ? 0 : 1
            let secondLabel = allItemLabels[otherIndex]
            point = secondLabel.center
        }
        changeThumbFrameForPoint(updatePoint(point!), animated: true)
        didEndTouchWithPoint(point!)
        allowToChangeThumb = false
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !allowDrag {
            return
        }
        
        let touch = touches.first
        let point = touch?.locationInView(self)
        isDragging = true
        didChangeDraggingState?(.Dragging)
        
        if point == nil {
            return
        }
        
        if !allowMove {
            return
        }
        allowToChangeThumb = false
        changeSelectedViewWidthFor(updatePoint(point!))
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInView(self)
        
        if point == nil {
            return
        }
        allowToChangeThumb = isSwitch
        allowMove = !isOutsideOfSelectionView(point!)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let touch = touches?.first
        var point = touch?.locationInView(self)
        
        isDragging = false
        didChangeDraggingState?(.Cancel)
        
        if point == nil {
            point = containerView.center
            
        }
        if point == nil {
            return
        }
        if isSwitch && allowToChangeThumb {
            let label = labelForPoint(thumbContainerView.center)
            let otherIndex = allItemLabels.indexOf(label) == 1 ? 0 : 1
            let secondLabel = allItemLabels[otherIndex]
            point = secondLabel.center
        }
        
        changeThumbFrameForPoint(updatePoint(point!), animated: true)
        didEndTouchWithPoint(point!)
        allowToChangeThumb = false
    }
    
    private func didEndTouchWithPoint(point: CGPoint) {
        let label = labelForPoint(point)
        
        let index = label.tag
        let title = label.text
        
        
        didSelectItemWith?(index: index, title: title)
        if title == nil {
            return
        }
    }
    
    private func isOutsideOfSelectionView(point: CGPoint) -> Bool {
        if thumbContainerView.frame.contains(point) {
            return false
        }
        return true
    }
}

//MARK: -  Frames

extension TTSegmentedControl {
    
    private func configureViewBounds() {
        let unselectedHeight = attributedDefaultTitles.map({$0.stringSize().height}).sort({$0 < $1}).last!
        let selectedHeight = attributedSelectedTitles.map({$0.stringSize().height}).sort({$0 < $1}).last!
        let unselectedWidth = attributedDefaultTitles.map({$0.stringSize().width}).sort({$0 < $1}).last!
        let selectedWidth = attributedSelectedTitles.map({$0.stringSize().width}).sort({$0 < $1}).last!
        
        frame.size.width = max(frame.size.width, CGFloat(attributedDefaultTitles.count) * (max(unselectedWidth, selectedWidth) + padding.width))
        frame.size.height = max(frame.size.height, max(unselectedHeight + padding.height, selectedHeight + padding.height))
        containerView.frame = self.bounds
    }
    
    private func updatePoint(point: CGPoint) -> CGPoint {
        return CGPointMake(max(minPoint.x - 0.1, min(maxPoint.x + 0.1, point.x)), containerView.frame.size.height/2)
    }
    
    private func selectItemForPoint(point: CGPoint) {
        let label = labelForPoint(point)
        updateSelectedViewFrameForLabel(label)
    }
    
    private func updateSelectedViewFrameForLabel(label: UILabel) {
        thumbContainerView.frame.size.width = label.frame.size.width + padding.width
        
    }
    
    private func changeThumbFrameForPoint(point: CGPoint, animated: Bool) {
        lastPointX = point.x
        let label = labelForPoint(point)
        let center = label.center
        originalCenter = center
        thumbContainerView.frame.size.height = containerView.frame.size.height
        
        let width = selectedViewWidthForPoint(point)
        let height = containerView.frame.size.height
        let originX = center.x - 0.5 * width
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? 0.4 : 0.0)
        shadowLayer.frame = CGRectMake(0, thumbPadding, width, height - 2 * thumbPadding)
        gradientLayer.frame = shadowLayer.bounds
        CATransaction.commit()
        
        if !animated {
            thumbContainerView.frame.size.width = width
            thumbContainerView.center = center
            
            let frame = CGRectMake(originX, 0, width, height)
            updateSelectedLabelsViewFrame(frame)
            
            lastSelectedViewWidth = thumbContainerView.frame.size.width
            return
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.thumbContainerView.frame.size.width = width
            self.thumbContainerView.center = center
            
            let frame = CGRectMake(originX, 0, width, height)
            self.updateSelectedLabelsViewFrame(frame)
            
            
        }) { (completed) in
            self.lastSelectedViewWidth = self.thumbContainerView.frame.size.width
        }
    }
    
    private func selectedViewWidthForPoint(point: CGPoint)-> CGFloat {
        if !allowChangeThumbWidth {
            return sectionWidth - 2 * thumbPadding
        }
        let label = labelForPoint(point)
        let index = allItemLabels.indexOf(label)!
        var width = label.frame.size.width + padding.height
        if index == 0 {
            width = 2 * label.center.x
        } else if index == (allItemLabels.count - 1)  {
            width = 2 * (containerView.frame.size.width - label.center.x)
        }
        return max(width, containerView.frame.size.height) - thumbPadding * 2
    }
    
    private func changeSelectedViewWidthFor(point: CGPoint) {
        
        let isGoingRight = lastPointX < point.x
        lastPointX = point.x
        
        let labels = labelsForPoint(point)
        var label = isGoingRight ? labels.leftLabel : labels.rightLabel
        var targetLabel = isGoingRight ? labels.rightLabel : labels.leftLabel
        
        var currentWidth: CGFloat = 0
        
        if allowChangeThumbWidth {
            if point.x < minPoint.x {
                label = labelForPoint(minPoint)
                targetLabel = labelForPoint(minPoint)
            } else if point.x > maxPoint.x {
                label = labelForPoint(maxPoint)
                targetLabel = labelForPoint(maxPoint)
            }
            
            let finalWidth = selectedViewWidthForPoint(targetLabel.center)
            let initialWidth = selectedViewWidthForPoint(label.center)
            
            let diff = fabs(initialWidth - finalWidth)
            
            let minOriginX = min(label.center.x, targetLabel.center.x)
            let maxOriginX = max(label.center.x, targetLabel.center.x)
            let centerDistance = maxOriginX - minOriginX
            let pointX = min(max(point.x, minOriginX), maxOriginX) - minOriginX
            
            var ratio = diff/centerDistance
            ratio = ratio == 0.0 ? 1 : ratio
            let width = pointX * ratio
            
            if initialWidth > finalWidth {
                currentWidth = isGoingRight ? initialWidth - width : finalWidth + width
            } else if initialWidth < finalWidth {
                currentWidth = isGoingRight ? initialWidth + width : finalWidth - width
            } else {
                currentWidth = initialWidth
            }
            
            currentWidth = pointX == 0 ? initialWidth : currentWidth
        } else {
            currentWidth = sectionWidth - 2 * thumbPadding
        }
        
        thumbContainerView.frame.size.width = currentWidth
        thumbContainerView.center = CGPoint(x: max(min(maxPoint.x, point.x), minPoint.x), y: thumbContainerView.center.y)
        
        updateSelectedLabelsViewFrame(thumbContainerView.frame)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        shadowLayer.frame = CGRectMake(0, thumbPadding, thumbView.bounds.size.width, thumbView.frame.size.height)
        gradientLayer.frame = shadowLayer.bounds
        CATransaction.commit()
    }
    
    private func labelsForPoint(point: CGPoint) -> (leftLabel: UILabel, rightLabel: UILabel){
        let label = labelForPoint(point)
        var secondLabel: UILabel!
        let index = allItemLabels.indexOf(label)!
        if point.x < label.center.x && index != 0 || index == (allItemLabels.count - 1) {
            secondLabel = allItemLabels[index - 1]
            return (leftLabel: secondLabel, rightLabel: label)
        } else if point.x > label.center.x && index != 0 || index == (allItemLabels.count - 1) {
            secondLabel = allItemLabels[index + 1]
            return (leftLabel: label, rightLabel: secondLabel)
        }
        return (leftLabel: label, rightLabel: label)
    }
    
    private func updateSelectedLabelsViewFrame(frame: CGRect) {
        var bounds = selectedLabelsView.bounds
        bounds.size.width = frame.size.width
        bounds.origin.x = frame.origin.x
        selectedLabelsView.bounds = bounds
        selectedLabelsView.frame.origin.x = frame.origin.x
    }
}

extension TTSegmentedControl {
    
    var currentIndex: Int {
        let label = labelForPoint(thumbContainerView.center)
        let index = allItemLabels.indexOf(label)!
        return index
    }
    
    public func selectItemAt(index index: Int, animated: Bool = false) {
        if !isConfigurated {
            selectInitialItem = index
            return
        }
        let label = allItemLabels[min(index, attributedDefaultTitles.count)]
        changeThumbFrameForPoint(label.center, animated: animated)
    }
    
    func changeTitle(title: String, atIndex: Int) {
        if !isConfigurated {
            return
        }
        
        let label = allItemLabels[atIndex]
        let selecteLabel = allSelectedItemLabels[atIndex]
        
        label.attributedText = attributedStringForText(title, isSelected: false)
        selecteLabel.attributedText = attributedStringForText(title, isSelected: true)
        
        let labelSize = label.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max))
        label.frame.size.width = min(sectionWidth, labelSize.width)
        label.frame.size.height = min(thumbView.frame.size.height, labelSize.height)
        label.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * label.frame.width
        label.frame.origin.y = (containerView.frame.size.height - label.frame.size.height)/2
        
        let selectedLabelSize = selecteLabel.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max))
        selecteLabel.frame.size.width = min(sectionWidth, selectedLabelSize.width)
        selecteLabel.frame.size.height = min(thumbView.frame.size.height, selectedLabelSize.height)
        selecteLabel.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * selecteLabel.frame.size.width
        selecteLabel.frame.origin.y = (containerView.frame.size.height - selecteLabel.frame.size.height)/2
        
        if attributedDefaultTitles != nil {
            attributedDefaultTitles![atIndex] = label.attributedText!
            attributedSelectedTitles![atIndex] = selecteLabel.attributedText!
        }
        
        itemTitles[atIndex] = title
        
    }
    
    func changeAttributedTitle(title: NSAttributedString, selectedTile: NSAttributedString?, atIndex: Int) {
        if !isConfigurated {
            return
        }
        
        let label = allItemLabels[atIndex]
        let selecteLabel = allSelectedItemLabels[atIndex]
        
        label.attributedText = title
        selecteLabel.attributedText = selectedTile
        
        let labelSize = label.sizeThatFits(CGSizeMake(CGFloat.max, containerView.frame.size.height - 5))
        label.frame.size.width = min(sectionWidth, labelSize.width)
        label.frame.size.height = min(thumbView.frame.size.height, labelSize.height)
        label.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * label.frame.width
        label.frame.origin.y = (containerView.frame.size.height - label.frame.size.height)/2
        
        let selectedLabelSize = selecteLabel.sizeThatFits(CGSizeMake(CGFloat.max, containerView.frame.size.height - 5))
        selecteLabel.frame.size.width = min(sectionWidth, selectedLabelSize.width)
        selecteLabel.frame.size.height = min(thumbView.frame.size.height, selectedLabelSize.height)
        selecteLabel.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * selecteLabel.frame.size.width
        selecteLabel.frame.origin.y = (containerView.frame.size.height - selecteLabel.frame.size.height)/2
        
        if attributedDefaultTitles != nil {
            attributedDefaultTitles![atIndex] = label.attributedText!
            attributedSelectedTitles![atIndex] = selecteLabel.attributedText!
            return
        }
        
        itemTitles[atIndex] = title.string
        
    }
    
    func titleForItemAtIndex(index: Int) -> String {
        if !isConfigurated {
            return ""
        }
        
        return attributedDefaultTitles[index].string
    }
    
    func attributedTitleAtIndex(index: Int) -> (normal: NSAttributedString, selected: NSAttributedString) {
        return (normal: attributedDefaultTitles[index], selected: attributedSelectedTitles[index])
    }
    
    func changeThumbShadowColor(color: UIColor) {
        if !isConfigurated {
            return
        }
        thumbShadowColor = color
        shadowLayer.shadowColor = color.CGColor
    }
    
    func changeThumbColor(color: UIColor) {
        if !isConfigurated {
            return
        }
        thumbColor = color
        thumbView.backgroundColor = color
    }
    
    func changeBackgroundColor(color: UIColor) {
        if !isConfigurated {
            return
        }
        containerBackgroundColor = color
        containerView.backgroundColor = color
    }
    
    func changeThumbGradientColors(colors: [UIColor]) {
        thumbGradientColors = colors
        gradientLayer.colors = thumbGradientColors!.map({$0.CGColor})
    }
}



//MARK: - UIView Extension

extension NSAttributedString {
    func stringSize() -> CGSize {
        return self.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: .UsesLineFragmentOrigin, context: nil).size
    }
}

extension UIFont {
    class func helveticaNeueLight(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
}
