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
        self.imageScaling = .scaleAxesIndependently
        // Drawing code here.
    }
    var index : Int?
    var section : Int?
    override func mouseDown(with event: NSEvent) {
        let destinationViewController = self.superview?.superview?.superview?.superview?.superview?.nextResponder as! ViewController
        let sourceViewController = self.superview?.superview?.superview?.superview?.superview?.superview?.nextResponder as! GalleryViewController
        let textField = self.superview?.subviews[1] as! NSTextField
        var tagName :String?
        if self.section == 0 {
            let g:[String:Any] = destinationViewController.galleryArray[self.index!] as! [String : Any]
            tagName = g["name"]! as? String
        } else {
            let t:[String:Any] = destinationViewController.tagsArray[self.index!] as! [String : Any]
            tagName = t["display_name"]! as? String
        }
        sourceViewController.tagsLabel.stringValue = textField.stringValue
        tagName = tagName?.replacingOccurrences(of: " ", with: "_")
        sourceViewController.galleryPosts.removeAll()
        sourceViewController.tagViewController = destinationViewController
        sourceViewController.authenticateAPI(tagName:tagName!)
        destinationViewController.dismissViewController(destinationViewController)
    }
}
