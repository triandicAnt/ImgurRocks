//
//  ImageFile.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/21/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class ImageFile {
    
    fileprivate(set) var thumbnail: NSImage?
    fileprivate(set) var fileName: String

    init?(thumbnail : NSImage, fileName: String) {
        self.thumbnail = thumbnail
        self.fileName = fileName
    }
    
}
