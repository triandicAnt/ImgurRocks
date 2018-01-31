//
//  GalleryImageView.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/28/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class GalleryImageView: NSImageView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.imageScaling = .scaleProportionallyUpOrDown
    }
    var index : Int?
    
    override func mouseDown(with event: NSEvent) {
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let destinationViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "post")) as! PostViewController
        let sourceViewController = self.superview?.superview?.superview?.superview?.nextResponder as! GalleryViewController
        sourceViewController.presentViewControllerAsSheet(destinationViewController)
        destinationViewController.galleryViewController = sourceViewController
        destinationViewController.processPost(post : sourceViewController.galleryPosts[self.index!])
    }
}
