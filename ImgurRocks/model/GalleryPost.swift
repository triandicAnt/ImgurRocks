//
//  GalleryPost.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/27/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class GalleryPost {
    
    fileprivate(set) var title: String?
    fileprivate(set) var homeImageUrl: URL?
    fileprivate(set) var imageUrls: [URL]?

    
    init?(homeImageUrl : URL, imageUrls:[URL], title: String) {
        self.homeImageUrl = homeImageUrl
        self.imageUrls = imageUrls
        self.title = title
    }
}

