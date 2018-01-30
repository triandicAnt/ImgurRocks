//
//  GalleryCollectionViewItem.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/27/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class GalleryCollectionViewItem: NSCollectionViewItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
}
