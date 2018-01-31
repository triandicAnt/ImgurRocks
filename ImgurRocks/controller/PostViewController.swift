//
//  PostViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/28/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class PostViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var scrollView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func processPost(post : GalleryPost) {
        self.textField.stringValue = post.title!
//        for image in post.images! {
//            if let image:NSImage = image {
//                let imgView = NSImageView()
//                imgView.image = image
//                self.scrollView.addSubview(imgView)
//            }
//        }
    }
}
