//
//  ContainerViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/27/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let sourceViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "gallery")) as! NSViewController
        self.insertChildViewController(sourceViewController, at: 0)
        self.view.addSubview(sourceViewController.view)
        self.view.frame = sourceViewController.view.frame
    }
}
