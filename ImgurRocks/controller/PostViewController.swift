//
//  PostViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/28/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

let leftArrowKey = 123
let rightArrowKey = 124
let escKey = 53
class PostViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    var imageUrls: [URL] = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(hex: "414a4c").cgColor
//        view.layer?.borderColor = NSColor.white.cgColor
        self.view.layer?.borderWidth = 0.0
        self.view.layer?.cornerRadius = 10.0
        configureCollectionView()
    }
    var galleryViewController: GalleryViewController?
    var index: Int?
    var imagesCount:Int = 0
    
    func processPost(post : GalleryPost) {
        self.textField.stringValue = post.title!
        self.imageUrls.removeAll()
        for url in post.imageUrls! {
                self.imageUrls.append(url)
        }
        self.collectionView.reloadData()
        self.scrollCollectionView(index: 0)
    }
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 500.0, height: 500.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor(hex: "309f98").cgColor
    }
    @IBAction func closeSheet(sender: NSButton) {
        galleryViewController?.dismissViewController(self)
        galleryViewController?.removeBlurredView()
    }
    override func keyUp(with event: NSEvent) {
//        super.keyUp(with: event)
        print(event.keyCode)
        if (event.keyCode == leftArrowKey) {
            // left is clicked
            // load previous post
            // check for the edge cases
            // the post can not be less than 0
            self.index = self.index! - 1
            if (self.index! >= (self.galleryViewController?.galleryPosts.count)!) {
                self.index! = (self.galleryViewController?.galleryPosts.count)! - 1
            }

            if self.index! >= 0 {
                self.processPost(post: (self.galleryViewController?.galleryPosts[self.index!])!)
            }
            
        } else if (event.keyCode == rightArrowKey) {
            // right is clicked
            // load the right post
            // check for the edge cases
            // the post can not be more than count
            self.index = self.index! + 1
            if (self.index! < 0) {
                self.index! = 0
            }
            if self.index! < (self.galleryViewController?.galleryPosts.count)! {
                self.processPost(post: (self.galleryViewController?.galleryPosts[self.index!])!)
            } else {
                var tagName = galleryViewController?.tagsLabel.stringValue
                tagName = tagName?.replacingOccurrences(of: " ", with: "_")

                galleryViewController?.pageNumber = (galleryViewController?.pageNumber)! + 1
                galleryViewController?.authenticateAPI(tagName: tagName!, pageNumber: (galleryViewController?.pageNumber)!)
            }
            print("Caught a key down: \(event.keyCode)!")
        } else if (event.keyCode == escKey) {
            galleryViewController?.dismissViewController(self)
            galleryViewController?.removeBlurredView()
        } else if (event.keyCode == 125) {
            // add logic to scroll to next item when the down button is pressed
            // also when up button is pressed, add logic to scroll up
            // check the number of items in the section and based on those items
            // if the items are less than 0 and set the value of the index to 0(reset it)
            // otherwise increase the index to 1 on down arrow key press and decrease by one on press
            // of up arrow press.
            self.imagesCount = self.imagesCount + 1
            if self.imagesCount >= self.imageUrls.count {
                self.imagesCount = self.imageUrls.count - 1
                return
            }
            self.scrollCollectionView(index: self.imagesCount)
        } else if (event.keyCode == 126) {
            self.imagesCount = self.imagesCount - 1
            if self.imagesCount < 0 {
                self.imagesCount = 0
                return
            }
            self.scrollCollectionView(index: self.imagesCount)
        }

    }
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    override func resignFirstResponder() -> Bool {
        return true
    }
    func scrollCollectionView(index : Int) {
        let section = 0
        let indexPath:NSIndexPath = NSIndexPath.init(forItem: index, inSection: section)
        self.collectionView.scrollToItems(at: Set([indexPath]) as Set<IndexPath>, scrollPosition: .bottom)
    }
}

extension PostViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        collectionView.register(PostCollectionViewItem.self, forItemWithIdentifier: .postCollectionViewItem)
        let item = collectionView.makeItem(withIdentifier: .postCollectionViewItem, for: indexPath)
        guard item is PostCollectionViewItem else {return item}
        item.imageView?.kf.indicatorType = .activity
        item.imageView?.kf.setImage(with: self.imageUrls[indexPath.item], placeholder: nil, options: nil,
                                    progressBlock: { receivedSize, totalSize in
        },
                                    completionHandler: { image, error, cacheType, imageURL in
        })
        item.imageView?.animates = true
        return item
    }
}

extension PostViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSZeroSize
    }
}
extension NSUserInterfaceItemIdentifier {
    static let postCollectionViewItem = NSUserInterfaceItemIdentifier("PostCollectionViewItem")
}
