//
//  SegmentController.swift
//  Segment
//
//  Created by Dumitru Igor on 7/28/16.
//  Copyright © 2016 Dumitru Igor. All rights reserved.
//

import UIKit


@IBDesignable
public class TTSegmentedControl: UIView {
    
    //Configure the options to for a custom design
    @IBInspectable open var defaultTextFont: UIFont = UIFont.helveticaNeueLight(12)
    @IBInspectable open var selectedTextFont: UIFont = UIFont.helveticaNeueLight(12)
    @IBInspectable open var defaultTextColor: UIColor = UIColor.black
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white
    @IBInspectable open var useGradient: Bool = true
    
    @IBInspectable open var containerBackgroundColor: UIColor = TTSegmentedControl.UIColorFromRGB(0xF4F4F4)
    @IBInspectable open var thumbColor: UIColor = UIColor.clear
    @IBInspectable open var thumbGradientColors: [UIColor]? = [TTSegmentedControl.UIColorFromRGB(0xFFE900),TTSegmentedControl.UIColorFromRGB(0xFFB400)]
    @IBInspectable open var thumbShadowColor: UIColor = TTSegmentedControl.UIColorFromRGB(0x9B9B9B)
    @IBInspectable open var useShadow:Bool = true
    
    //left and right space between items
    @IBInspectable open var padding: CGSize = CGSize(width: 30, height: 10)
    @IBInspectable open var cornerRadius: CGFloat = -1 // for rounded corner radius use negative value, 0 to disable
    
    public enum DraggingState: Int {
        case none
        case dragging
        case cancel
    }
    
    open var animationOptions:BounceOptions = BounceOptions()
    open var hasBounceAnimation:Bool = false
    public struct BounceOptions {
        var springDamping:CGFloat = 0.7
        var springInitialVelocity:CGFloat = 0.2
        var options:UIViewAnimationOptions = .curveEaseInOut
    }
    
    open var itemTitles: [String] = ["Item1", "Item2", "Item3"]
    
    var attributedDefaultTitles: [NSAttributedString]!
    var attributedSelectedTitles: [NSAttributedString]!
    /*
     Gets called when an item is selected
     */
    open var didSelectItemWith:((_ index: Int, _ title: String?) -> ())?
    /*
     Gets called when the dragging state is changed
     */
    open var didChangeDraggingState: ((DraggingState) -> ())?
    
    fileprivate(set) var isDragging = false
    open var allowDrag = true
    open var allowChangeThumbWidth = true
    
    fileprivate var containerView = UIView()
    fileprivate var thumbContainerView = UIView()
    fileprivate var thumbView = UIView()
    fileprivate var selectedLabelsView = UIView()
    
    fileprivate var isConfigurated = false
    fileprivate var lastPointX: CGFloat = 0
    fileprivate var originalCenter = CGPoint.zero
    fileprivate var lastSelectedViewWidth: CGFloat = 0
    
    
    fileprivate let thumbPadding: CGFloat = 2
    
    fileprivate let shadowLayer = CAShapeLayer()
    fileprivate var gradientLayer = CAGradientLayer()
    
    fileprivate var allowToChangeThumb = false
    fileprivate var allowMove = true
    fileprivate var selectInitialItem = 0
    fileprivate var currentSelectedIndex = 0
    
    open var noItemSelected:Bool = false {
        didSet {
            self.thumbView.isHidden = noItemSelected
            self.selectedLabelsView.isHidden = noItemSelected
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isConfigurated {
            configureItemsConent()
            configureViewBounds()
            
            configureContainerView()
            configureItems()
            configureSelectedView()
            configureSelectedLabelsView()
            configureSelectedLabelItems()
            
            isConfigurated = true
        }
        
        containerView.frame = bounds
        containerView.layer.cornerRadius = cornerRadius < 0 ? 0.5 * containerView.frame.size.height : cornerRadius
        selectedLabelsView.frame = containerView.bounds
        
        updateFrameForLables(allItemLabels)
        updateFrameForLables(allSelectedItemLabels)
        updateSelectedViewFrame()
        
        selectItemAt(index:currentSelectedIndex)
        _ = self.subviews.map({$0.isExclusiveTouch = true})
        
    }
    
    //MARK: - Getters
    fileprivate var allItemLabels: [UILabel] = []
    fileprivate var allSelectedItemLabels: [UILabel] = []
    
    fileprivate var sectionWidth: CGFloat {
        return self.frame.size.width / CGFloat(allItemLabels.count)
    }
    
    fileprivate var minPoint: CGPoint {
        return allItemLabels[0].center
    }
    
    fileprivate var maxPoint: CGPoint {
        return allSelectedItemLabels[allSelectedItemLabels.count - 1].center
    }
    
    fileprivate var minContainerWidth: Int {
        return 100
    }
    
    fileprivate var isSwitch: Bool {
        return attributedDefaultTitles.count == 2
    }
    
    //MARK: - Helpers
    static public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    fileprivate func labelForPoint(_ point: CGPoint) -> UILabel {
        var pointX = max(point.x, thumbPadding)
        pointX = min(pointX , containerView.frame.size.width - thumbPadding)
        
        let newPoint = CGPoint(x: pointX, y: point.y)
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
    
    fileprivate func selectedLabelForPoint(_ point: CGPoint) -> UILabel {
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
    
    fileprivate func configureSelectedView() {
        containerView.addSubview(thumbContainerView)
        thumbContainerView.addSubview(thumbView)
        
        thumbContainerView.backgroundColor = UIColor.clear
        thumbView.backgroundColor = thumbColor
        
        thumbView.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
        
        if useShadow {
            shadowLayer.shadowColor = thumbShadowColor.cgColor
            shadowLayer.backgroundColor = thumbColor.cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 1);
            shadowLayer.shadowOpacity = 0.6;
            shadowLayer.shadowRadius = 3
            shadowLayer.masksToBounds = false
            
            thumbContainerView.layer.insertSublayer(shadowLayer, at: 0)
        }
        
        if thumbGradientColors != nil && self.useGradient {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.backgroundColor = thumbColor.cgColor
            gradientLayer.colors = thumbGradientColors!.map({$0.cgColor})
            thumbView.backgroundColor = UIColor.clear
            thumbView.layer.addSublayer(gradientLayer)
        }
    }
    
    fileprivate func configureContainerView() {
        containerView.backgroundColor = containerBackgroundColor
        self.addSubview(containerView)
    }
    
    fileprivate func configureSelectedLabelsView() {
        selectedLabelsView.backgroundColor = UIColor.clear
        selectedLabelsView.clipsToBounds = true
        selectedLabelsView.isUserInteractionEnabled = false
        containerView.addSubview(selectedLabelsView)
    }
    
    
    fileprivate func configureItemsConent() {
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
    
    fileprivate func configureItems() {
        var i = 0
        for title in attributedDefaultTitles {
            let label = createLabelWithTitle(title, tag: i)
            containerView.addSubview(label)
            allItemLabels.append(label)
            i += 1
        }
    }
    
    fileprivate func configureSelectedLabelItems() {
        var i = 0
        for title in attributedSelectedTitles {
            let label = createLabelWithTitle(title, tag: i)
            selectedLabelsView.addSubview(label)
            allSelectedItemLabels.append(label)
            i += 1
        }
    }
    
    fileprivate func createLabelWithTitle(_ attributedTitle: NSAttributedString, tag: Int) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = attributedTitle
        label.tag = tag
        return label
        
    }
    
    fileprivate func attributedStringForText(_ text: String, isSelected: Bool) -> NSAttributedString {
        let textColor = isSelected ? selectedTextColor : defaultTextColor
        let textFont = isSelected ? selectedTextFont : defaultTextFont
        
        let attributes = [NSAttributedStringKey.foregroundColor : textColor,
                          NSAttributedStringKey.font : textFont]
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}

extension TTSegmentedControl {
    
    fileprivate func updateSelectedViewFrame() {
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
    
    fileprivate func updateFrameForLables(_ allLabels: [UILabel]) {
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
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var point = touch?.location(in: self)
        isDragging = false
        didChangeDraggingState?(.none)
        
        if point == nil {
            return
        }
        if isSwitch && allowToChangeThumb {
            let label = labelForPoint(thumbContainerView.center)
            let otherIndex = allItemLabels.index(of: label) == 1 ? 0 : 1
            let secondLabel = allItemLabels[otherIndex]
            point = secondLabel.center
        }
        changeThumbFrameForPoint(updatePoint(point!), animated: true)
        didEndTouchWithPoint(point!)
        allowToChangeThumb = false
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !allowDrag {
            return
        }
        
        let touch = touches.first
        let point = touch?.location(in: self)
        isDragging = true
        didChangeDraggingState?(.dragging)
        
        if point == nil {
            return
        }
        
        if !allowMove {
            return
        }
        allowToChangeThumb = false
        changeSelectedViewWidthFor(updatePoint(point!))
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        
        if point == nil {
            return
        }
        allowToChangeThumb = isSwitch
        allowMove = !isOutsideOfSelectionView(point!)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var point = touch?.location(in: self)
        
        isDragging = false
        didChangeDraggingState?(.cancel)
        
        if point == nil {
            point = containerView.center
            
        }
        if point == nil {
            return
        }
        if isSwitch && allowToChangeThumb {
            let label = labelForPoint(thumbContainerView.center)
            let otherIndex = allItemLabels.index(of: label) == 1 ? 0 : 1
            let secondLabel = allItemLabels[otherIndex]
            point = secondLabel.center
        }
        
        changeThumbFrameForPoint(updatePoint(point!), animated: true)
        didEndTouchWithPoint(point!)
        allowToChangeThumb = false
    }
    
    fileprivate func didEndTouchWithPoint(_ point: CGPoint) {
        let label = labelForPoint(point)
        
        let index = label.tag
        let title = label.text
        self.currentSelectedIndex = index
        
        didSelectItemWith?(index, title)
        if title == nil {
            return
        }
    }
    
    fileprivate func isOutsideOfSelectionView(_ point: CGPoint) -> Bool {
        if thumbContainerView.frame.contains(point) {
            return false
        }
        return true
    }
}

//MARK: -  Frames

extension TTSegmentedControl {
    
    fileprivate func configureViewBounds() {
        let unselectedHeight = attributedDefaultTitles.map({$0.stringSize().height}).sorted(by: {$0 < $1}).last!
        let selectedHeight = attributedSelectedTitles.map({$0.stringSize().height}).sorted(by: {$0 < $1}).last!
        let unselectedWidth = attributedDefaultTitles.map({$0.stringSize().width}).sorted(by: {$0 < $1}).last!
        let selectedWidth = attributedSelectedTitles.map({$0.stringSize().width}).sorted(by: {$0 < $1}).last!
        
        frame.size.width = max(frame.size.width, CGFloat(attributedDefaultTitles.count) * (max(unselectedWidth, selectedWidth) + padding.width))
        frame.size.height = max(frame.size.height, max(unselectedHeight + padding.height, selectedHeight + padding.height))
        containerView.frame = self.bounds
    }
    
    fileprivate func updatePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: max(minPoint.x - 0.1, min(maxPoint.x + 0.1, point.x)), y: containerView.frame.size.height/2)
    }
    
    fileprivate func selectItemForPoint(_ point: CGPoint) {
        let label = labelForPoint(point)
        updateSelectedViewFrameForLabel(label)
    }
    
    fileprivate func updateSelectedViewFrameForLabel(_ label: UILabel) {
        thumbContainerView.frame.size.width = label.frame.size.width + padding.width
        
    }
    
    fileprivate func changeThumbFrameForPoint(_ point: CGPoint, animated: Bool) {
        
        selectedLabelsView.isHidden = false
        thumbView.isHidden = false
        
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
        shadowLayer.frame = CGRect(x: 0, y: thumbPadding, width: width, height: height - 2 * thumbPadding)
        gradientLayer.frame = shadowLayer.bounds
        CATransaction.commit()
        
        if !animated {
            thumbContainerView.frame.size.width = width
            thumbContainerView.center = center
            
            let frame = CGRect(x: originX, y: 0, width: width, height: height)
            updateSelectedLabelsViewFrame(frame)
            
            lastSelectedViewWidth = thumbContainerView.frame.size.width
            return
        }
        
        self.animate({
            self.thumbContainerView.frame.size.width = width
            self.thumbContainerView.center = center
            
            let frame = CGRect(x: originX, y: 0, width: width, height: height)
            self.updateSelectedLabelsViewFrame(frame)
        }) { (completed) in
            self.lastSelectedViewWidth = self.thumbContainerView.frame.size.width
        }
    }
    
    fileprivate func animate(_ block:@escaping () -> Void, completion:@escaping (Bool)-> Void) {
        
        if hasBounceAnimation {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: animationOptions.springDamping, initialSpringVelocity: animationOptions.springInitialVelocity, options: animationOptions.options  , animations: {
                block()
            }) { (completed) in
                completion(completed)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
               block()
            }, completion: { (completed) in
                completion(completed)
            })
        }

    }
    
    fileprivate func selectedViewWidthForPoint(_ point: CGPoint)-> CGFloat {
        if !allowChangeThumbWidth {
            return sectionWidth - 2 * thumbPadding
        }
        let label = labelForPoint(point)
        let index = allItemLabels.index(of: label)!
        var width = label.frame.size.width + padding.height
        if index == 0 {
            width = 2 * label.center.x
        } else if index == (allItemLabels.count - 1)  {
            width = 2 * (containerView.frame.size.width - label.center.x)
        }
        return max(width, containerView.frame.size.height) - thumbPadding * 2
    }
    
    fileprivate func changeSelectedViewWidthFor(_ point: CGPoint) {
        
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
        shadowLayer.frame = CGRect(x: 0, y: thumbPadding, width: thumbView.bounds.size.width, height: thumbView.frame.size.height)
        gradientLayer.frame = shadowLayer.bounds
        CATransaction.commit()
    }
    
    fileprivate func labelsForPoint(_ point: CGPoint) -> (leftLabel: UILabel, rightLabel: UILabel){
        let label = labelForPoint(point)
        var secondLabel: UILabel!
        let index = allItemLabels.index(of: label)!
        if point.x < label.center.x && index != 0 || index == (allItemLabels.count - 1) {
            secondLabel = allItemLabels[index - 1]
            return (leftLabel: secondLabel, rightLabel: label)
        } else if point.x > label.center.x && index != 0 || index == (allItemLabels.count - 1) {
            secondLabel = allItemLabels[index + 1]
            return (leftLabel: label, rightLabel: secondLabel)
        }
        return (leftLabel: label, rightLabel: label)
    }
    
    fileprivate func updateSelectedLabelsViewFrame(_ frame: CGRect) {
        var bounds = selectedLabelsView.bounds
        bounds.size.width = frame.size.width
        bounds.origin.x = frame.origin.x
        selectedLabelsView.bounds = bounds
        selectedLabelsView.frame.origin.x = frame.origin.x
    }
}

extension TTSegmentedControl {
    
    open var currentIndex: Int {
        if !isConfigurated {
            return 0
        }
        let label = labelForPoint(thumbContainerView.center)
        let index = allItemLabels.index(of: label)
        return index ?? 0
    }
    
    public func selectItemAt(index: Int, animated: Bool = false) {
        if !isConfigurated {
            selectInitialItem = index
            return
        }
        let label = allItemLabels[min(index, attributedDefaultTitles.count)]
        selectedLabelsView.isHidden = noItemSelected
        changeThumbFrameForPoint(label.center, animated: animated)
    }
    
    open func changeTitle(_ title: String, atIndex: Int) {
        if !isConfigurated {
            return
        }
        
        let label = allItemLabels[atIndex]
        let selecteLabel = allSelectedItemLabels[atIndex]
        
        label.attributedText = attributedStringForText(title, isSelected: false)
        selecteLabel.attributedText = attributedStringForText(title, isSelected: true)
        
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size.width = min(sectionWidth, labelSize.width)
        label.frame.size.height = min(thumbView.frame.size.height, labelSize.height)
        label.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * label.frame.width
        label.frame.origin.y = (containerView.frame.size.height - label.frame.size.height)/2
        
        let selectedLabelSize = selecteLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
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
    
    open func changeAttributedTitle(_ title: NSAttributedString, selectedTile: NSAttributedString?, atIndex: Int) {
        if !isConfigurated {
            return
        }
        
        let label = allItemLabels[atIndex]
        let selecteLabel = allSelectedItemLabels[atIndex]
        
        label.attributedText = title
        selecteLabel.attributedText = selectedTile
        
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: containerView.frame.size.height - 5))
        label.frame.size.width = min(sectionWidth, labelSize.width)
        label.frame.size.height = min(thumbView.frame.size.height, labelSize.height)
        label.frame.origin.x = ((sectionWidth * CGFloat(tag)) - (0.5 * sectionWidth)) - 0.5 * label.frame.width
        label.frame.origin.y = (containerView.frame.size.height - label.frame.size.height)/2
        
        let selectedLabelSize = selecteLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: containerView.frame.size.height - 5))
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
    
    open func titleForItemAtIndex(_ index: Int) -> String {
        if !isConfigurated {
            return ""
        }
        
        return attributedDefaultTitles[index].string
    }
    
    open func attributedTitleAtIndex(_ index: Int) -> (normal: NSAttributedString, selected: NSAttributedString) {
        return (normal: attributedDefaultTitles[index], selected: attributedSelectedTitles[index])
    }
    
    open func changeThumbShadowColor(_ color: UIColor) {
        if !isConfigurated {
            return
        }
        thumbShadowColor = color
        shadowLayer.shadowColor = color.cgColor
    }
    
    open func changeThumbColor(_ color: UIColor) {
        if !isConfigurated {
            return
        }
        thumbColor = color
        thumbView.backgroundColor = color
    }
    
    open func changeBackgroundColor(_ color: UIColor) {
        if !isConfigurated {
            return
        }
        containerBackgroundColor = color
        containerView.backgroundColor = color
    }
    
    open func changeThumbGradientColors(_ colors: [UIColor]) {
        thumbGradientColors = colors
        gradientLayer.colors = thumbGradientColors!.map({$0.cgColor})
    }
}



//MARK: - UIView Extension

extension NSAttributedString {
    func stringSize() -> CGSize {
        return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
    }
}

extension UIFont {
    class func helveticaNeueLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
}

