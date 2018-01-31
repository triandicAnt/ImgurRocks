//
//  HomeWindowController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/21/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class HomeWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window, let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width/2.0, height: screenRect.height), display: true)
        }
    }
}

