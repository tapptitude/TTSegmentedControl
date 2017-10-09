//
//  ViewController.swift
//  TTSegmentedControlSample
//
//  Created by Efraim Budusan on 10/8/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentedControl.noItemSelected = true
        segmentedControl.hasBounceAnimation = true 
    }
    
}

