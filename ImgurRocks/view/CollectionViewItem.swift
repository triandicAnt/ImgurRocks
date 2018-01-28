//
//  CollectionViewItem.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/23/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//


import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = 0.0
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 0.0
        view.layer?.cornerRadius = 8.0
    }
    
}

