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
        let containerViewController = self.window?.windowController?.contentViewController
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let destinationViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "gallery")) as! NSViewController
//        containerViewController?.insertChildViewController(destinationViewController, at: 0)
//        containerViewController?.view.addSubview(destinationViewController.view)
//        containerViewController?.view.frame = destinationViewController.view.frame
        
        
        containerViewController?.presentViewController(destinationViewController, animator: MyTransitionAnimator())
        // get the size of destinationViewController
        let targetSize = destinationViewController.view.frame.size
        let targetWidth = destinationViewController.view.frame.size.width
        let targetHeight = destinationViewController.view.frame.size.height
//
//        // prepare for animation
//        sourceViewController.view.wantsLayer = true
//        destinationViewController.view.wantsLayer = true
//
//        //perform transition
//        containerViewController.transition(from: sourceViewController, to: destinationViewController, options: NSViewControllerTransitionOptions.crossfade, completionHandler: nil)
//
//        //resize view controllers
//        sourceViewController.view.animator().setFrameSize(targetSize)
//        destinationViewController.view.animator().setFrameSize(targetSize)
//
//        //resize and shift window
//        let currentFrame = containerViewController.view.window?.frame
//        let currentRect = NSRectToCGRect(currentFrame!)
//        let horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
//        let verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
//        let newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange, currentRect.origin.y - verticalChange, targetWidth, targetHeight)
//        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: true)
//
//
//        print(self.window?.contentView?.subviews)

    }
    
}
