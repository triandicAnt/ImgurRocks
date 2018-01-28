//
//  MyTransitionAnimator.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/27/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class MyTransitionAnimator: NSObject, NSViewControllerPresentationAnimator {
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        
        // make sure the view has a CA layer for smooth animation
        topVC.view.wantsLayer = true
        
        // set redraw policy
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        // start out invisible
        topVC.view.alphaValue = 0
        
        // add view of presented viewcontroller
        bottomVC.view.addSubview(topVC.view)
        
        // adjust size
        topVC.view.frame = bottomVC.view.frame
        
        // Do some CoreAnimation stuff to present view
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            
            // fade duration
            context.duration = 2
            // animate to alpha 1
            topVC.view.animator().alphaValue = 1
            
        }, completionHandler: nil)
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let topVC = viewController
        // make sure the view has a CA layer for smooth animation
        topVC.view.wantsLayer = true
        
        // set redraw policy
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        // Do some CoreAnimation stuff to present view
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            
            // fade duration
            context.duration = 2
            // animate view to alpha 0
            topVC.view.animator().alphaValue = 0
            
        }, completionHandler: {
            
            // remove view
            topVC.view.removeFromSuperview()
        })
    }
}

