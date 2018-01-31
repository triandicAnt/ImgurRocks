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
    @IBOutlet weak var collectionView: NSCollectionView!
    var imageUrls: [URL] = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    var galleryViewController: GalleryViewController?
    
    func processPost(post : GalleryPost) {
        self.textField.stringValue = post.title!
        for url in post.imageUrls! {
                self.imageUrls.append(url)
        }
        print(imageUrls.count)
        self.collectionView.reloadData()
    }
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 500.0, height: 500.0)
        //flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        //flowLayout.minimumInteritemSpacing = 10.0
        //flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor(hex: "309f98").cgColor
    }
    @IBAction func closeSheet(sender: NSButton) {
//        let destinationViewController = self.view.superview?.nextResponder as! NSViewController
        print(galleryViewController!)
        galleryViewController?.dismissViewController(self)
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
