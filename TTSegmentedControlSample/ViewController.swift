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
        segmentedControl.selectItemAt(index: 2, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        segmentedControl.noItemSelected = true
        segmentedControl.hasBounceAnimation = true
    }
    @IBAction func buttonAction(_ sender: Any) {
        segmentedControl.selectItemAt(index: 0, animated: false)
    }
    
}

