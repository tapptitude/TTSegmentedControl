//
//  ViewController.swift
//  TTSegmentedControlSample
//
//  Created by Efraim Budusan on 10/8/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import UIKit
import TTSegmentedControl

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectItemAt(index: 2, animated: false)
        
        useImageInsideAttributes(image: UIImage(named: "phone")!, atIndex: 2)
        addImageInsideAttributes(image: UIImage(named: "phone")!, atIndex: 1)
    }

    func addImageInsideAttributes(image: UIImage, atIndex: Int) {
        // ask segmented control to initialize all elements internally
        segmentedControl.layoutSubviews()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        let attributes = segmentedControl.attributedDefaultTitles.first?.mutableCopy() as! NSMutableAttributedString
        attributes.append(NSAttributedString(attachment: imageAttachment))
        
        let selectedAttributes = segmentedControl.attributedSelectedTitles.first?.mutableCopy() as! NSMutableAttributedString
        selectedAttributes.append(NSAttributedString(attachment: imageAttachment))
        
        segmentedControl.changeAttributedTitle(attributes, selectedTile: selectedAttributes, atIndex: atIndex)
    }
    
    func useImageInsideAttributes(image: UIImage, atIndex: Int) {
        // ask segmented control to initialize all elements internally
        segmentedControl.layoutSubviews()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        let attributes = NSAttributedString(attachment: imageAttachment)
        
        segmentedControl.changeAttributedTitle(attributes, selectedTile: attributes, atIndex: atIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        segmentedControl.noItemSelected = true
        segmentedControl.hasBounceAnimation = true
        
    }
    @IBAction func buttonAction(_ sender: Any) {
        
        segmentedControl.defaultTextColor = UIColor.red
        segmentedControl.reconfigure()
    
    }
    
}

