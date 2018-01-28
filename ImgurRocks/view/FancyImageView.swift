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
        print("mousedown in image")
//        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
//        let currentViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "gallery")) as! GalleryViewController
        let destinationViewController = self.superview?.superview?.superview?.superview?.superview?.nextResponder as! NSViewController
        let sourceViewController = self.superview?.superview?.superview?.superview?.superview?.superview?.nextResponder as! GalleryViewController
        let textField = self.superview?.subviews[1] as! NSTextField
        sourceViewController.galleryPosts.removeAll()
        sourceViewController.authenticateAPI(tagName:textField.stringValue)
        destinationViewController.dismissViewController(destinationViewController)
    }
}
