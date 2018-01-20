//
//  ViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/18/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the Imgur API and fetch data
        authenticateAPI()
        
    }
    
    func authenticateAPI() {
        print("Hello Imgur");
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

