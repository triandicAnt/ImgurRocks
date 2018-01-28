//
//  GalleryPost.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/27/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class GalleryPost {
    
    fileprivate(set) var homeImage: NSImage?
    fileprivate(set) var title: String?
    fileprivate(set) var images: [NSImage]?

    
    init?(homeImage : NSImage, title: String, images:[NSImage]) {
        self.homeImage = homeImage
        self.title = title
        self.images = images
    }
    
}

