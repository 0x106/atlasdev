//
//  ViewController.swift
//  atlasdev
//
//  Created by Jordan-Campbell on 10/16/2017.
//  Copyright (c) 2017 Jordan-Campbell. All rights reserved.
//

import UIKit
import atlasdev

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let obj = Atlasdev()
        
        obj.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

