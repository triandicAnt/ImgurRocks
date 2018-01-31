//
//  PostImageView.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/30/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class PostImageView: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.imageScaling = .scaleProportionallyUpOrDown
    }
}
