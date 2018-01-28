//
//  FancyImageView.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/23/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class FancyImageView: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.imageScaling = .scaleProportionallyUpOrDown
        // Drawing code here.
    }
    
    override func mouseDown(with event: NSEvent) {
        print("mouse clicked")
        for sView in (self.window?.contentView?.subviews)! {
            //sView.removeFromSuperview()
            print(sView)
        }
        let viewController = ViewController(nibName: NSNib.Name(rawValue: "GalleryViewController"), bundle: Bundle.main)
        self.window?.contentView?.addSubview(viewController.view)
//        viewController.view.frame = (self.window?.contentView?.bounds)!
    }
    
}
