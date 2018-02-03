//
//  GalleryViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/24/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa
import Kingfisher
//import ProgressKit

class GalleryViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var tagsButton :NSButton!
    @IBOutlet weak var matureButton: NSButton!
    @IBOutlet weak var viralButton: NSButton!
    @IBOutlet weak var sectionBox: NSBox!
    @IBOutlet weak var sortBox: NSBox!
    @IBOutlet weak var tagsLabel: NSTextField!
    var sortString:String!
    var sectionString:String!
    var blurView: NSVisualEffectView?
    let apiManager = APIManager()
    var galleryPosts : [GalleryPost] = [GalleryPost]()
    var pageNumber: Int = 1
    var tagViewController : ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor(hex: "414a4c").cgColor
//        self.tagsButton.layer?.backgroundColor = NSColor(hex: "FFFFFF").cgColor
        self.sortString = "viral"
        self.sectionString = "hot"
        sectionBox.alphaValue = 1
        sectionBox.borderColor = NSColor.red
        sectionBox.borderType = .lineBorder
        sectionBox.borderWidth = 5
        sortBox.alphaValue = 1
        sortBox.borderColor = NSColor.red
        sortBox.borderType = .lineBorder
        sortBox.borderWidth = 5
        let style = NSMutableParagraphStyle()
        matureButton.attributedTitle = NSMutableAttributedString(string: "Mature", attributes: [NSAttributedStringKey.foregroundColor: NSColor.white, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 11)])
        viralButton.attributedTitle = NSMutableAttributedString(string: "Viral", attributes: [NSAttributedStringKey.foregroundColor: NSColor.white, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 11)])
        for view in self.sortBox.subviews {
            let button:NSButton = view as! NSButton
            button.attributedTitle = NSMutableAttributedString(string: button.title, attributes: [NSAttributedStringKey.foregroundColor: NSColor.white, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 11)])
        }
        for view in self.sectionBox.subviews {
            let button:NSButton = view as! NSButton
            button.attributedTitle = NSMutableAttributedString(string: button.title, attributes: [NSAttributedStringKey.foregroundColor: NSColor.white, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 11)])
        }
        let scrollView = collectionView.superview?.superview as? NSScrollView
        scrollView?.autohidesScrollers = true
        scrollView?.scrollerStyle = .overlay
        configureCollectionView()
//        for view in self.view.subviews {
//            (view as? IndeterminateAnimation)?.animate = true
//        }
        authenticateAPI()
//        self.blur(view: self.view)
    }
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 300.0, height: 300.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        //        collectionView.layer?.backgroundColor = NSColor.black.cgColor # 414a4c
        collectionView.layer?.backgroundColor = NSColor(hex: "309f98").cgColor
    }
    
    @IBAction func loadTags(sender: NSButton) {
        let animator = MyCustomSwiftAnimator()
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let destinationViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "tags")) as! ViewController
        destinationViewController.galleryViewController = self
        self.presentViewController(destinationViewController, animator: animator)
    }
    func applyBlurToWindow() {
        // define the visual effect view
        self.blurView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: (NSApplication.shared.windows.first?.frame.width)!, height: (NSApplication.shared.windows.first?.frame.height)!))
        // this is default value but is here for clarity
        blurView?.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        // set the background to always be the dark blur
        blurView?.material = NSVisualEffectView.Material.mediumLight
        blurView?.wantsLayer = true
        blurView?.layer?.backgroundColor = NSColor.clear.cgColor
        blurView?.layer?.masksToBounds = true
        blurView?.layerUsesCoreImageFilters = true
        blurView?.layer?.needsDisplayOnBoundsChange = true
        let satFilter = CIFilter(name: "CIColorControls")
        satFilter?.setDefaults()
        satFilter?.setValue(NSNumber(value: 0.0), forKey: "inputSaturation")
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(NSNumber(value: 2.0), forKey: "inputRadius")
        blurView?.layer?.backgroundFilters = [satFilter!, blurFilter!]

        // set it to always be blurry regardless of window state
        if let window = NSApplication.shared.windows.first {
            window.acceptsMouseMovedEvents = true
            blurView?.state = .active
            window.contentView?.addSubview(blurView!)
        }
    }
    
    func removeBlurredView(){
        blurView?.state = .inactive
        blurView?.layer?.backgroundFilters = nil
        self.blurView?.removeFromSuperview()
    }

    @IBAction func sortBy(sender: NSButton) {
        sortString = sender.title.lowercased()
    }
    @IBAction func sectionBy(sender: NSButton) {
        sectionString = sender.title.lowercased()
    }
    func authenticateAPI(tagName :String = "funny", pageNumber :Int = 1) {
        let tagUrl = Utils.GALLERY_TAG_URL + tagName + "/" + self.sortString + "/" + String(pageNumber)
        apiManager.fetchGalleryAPIImages(tagName: tagUrl, mature: self.matureButton.state.rawValue, viral: self.viralButton.state.rawValue) { responseObject, error in
            self.processData(data: responseObject!) {posts,error in
                self.collectionView.reloadData()
//                for view in self.view.subviews {
//                    (view as? IndeterminateAnimation)?.animate = false
//                }
            }
        }
    }
    
    func processData (data: Data, completionHandler: @escaping ([Any]?, NSError?) -> ()) {
        do {
            if let jsonVal = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                let jsonValueData:[String : Any] = (jsonVal["data"] as? [String : Any])!
                print(String(jsonValueData.count) + "-------------------")
                let items:[Any] = (jsonValueData["items"] as? [Any])!
                for item in items {
                    let post:[String:Any] = item as! [String : Any]
                    let title:String = (post["title"] as? String)!
                    var imageUrls : [URL] = [URL]()
                    if let imageFiles = post["images"] {
                        let imgDict:[Any] = (imageFiles as? [Any])!
                        for image in imgDict {
                            let img:[String:Any] = image as! [String : Any]
                            let imgUrl:String = img["link"] as! String
                            let url = URL(string: imgUrl)
                            let fileExt = NSURL(fileURLWithPath: imgUrl).pathExtension
                            // image view not able to handle mp4s
                            if fileExt == "mp4" {
                                continue
                            }
                            imageUrls.append(url!)
                        }
                    }
                    else if let imageFiles = post["gifv"] {
                        let imgUrl:String = imageFiles as! String
                        let indexEndOfText = imgUrl.index(imgUrl.endIndex, offsetBy: -1)
                        let substring2 = imgUrl[..<indexEndOfText]
                        let url = URL(string: String(substring2))
                        imageUrls.append(url!)
                    }
                    if imageUrls.count > 0 {
                        let gp: GalleryPost = GalleryPost(homeImageUrl: imageUrls[0], imageUrls: imageUrls, title: title)!
                        self.galleryPosts.append(gp)
                    }
                }
                completionHandler(self.galleryPosts, nil)
            }
        } catch let err{
            print(err.localizedDescription)
        }
    }
    func downloadedFrom(url: URL, completionHandler: @escaping (NSImage?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = NSImage(data: data)
                else {
                    return completionHandler(nil, error)
            }
            DispatchQueue.main.async() {
                completionHandler(image, nil)
            }
            }.resume()
    }
    func downloadedFrom(link: String, completionHandler: @escaping (NSImage?, Error?) -> ()) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, completionHandler: completionHandler)
    }
    override func keyUp(with event: NSEvent) {
        print(event.keyCode)
        if (event.keyCode == escKey) {
            if (self.tagViewController != nil) {
                self.dismissViewController(self.tagViewController!)
            }
        }
    }
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        if (event.keyCode == escKey) {
            self.dismissViewController(self)
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
}

extension GalleryViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryPosts.count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        collectionView.register(GalleryCollectionViewItem.self, forItemWithIdentifier: .collectionViewItem)
        let item = collectionView.makeItem(withIdentifier: .collectionViewItem, for: indexPath)
        guard let collectionViewItem = item as? GalleryCollectionViewItem else {return item}
        let post:GalleryPost = self.galleryPosts[indexPath.item]
        item.imageView?.kf.indicatorType = .activity
        item.imageView?.kf.setImage(with: post.homeImageUrl, placeholder: nil, options: nil,
                                    progressBlock: { receivedSize, totalSize in
                                    },
                                    completionHandler: { image, error, cacheType, imageURL in
                                    })
        item.imageView?.animates = true
        let galleryImgView = collectionViewItem.imageView as! GalleryImageView
        galleryImgView.index = indexPath.item
        return item
    }
}

extension GalleryViewController :NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        if indexPath.item == self.galleryPosts.count-1 {
            self.pageNumber = self.pageNumber + 1
            self.authenticateAPI(pageNumber: self.pageNumber)
        }
    }
}

extension GalleryViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSZeroSize
    }
}

//extension NSImage {
//    func downloadedFrom(url: URL, completionHandler: @escaping (NSImage?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = NSImage(data: data)
//                else {
//                    completionHandler(nil, error)
//                }
//            DispatchQueue.main.async() {
//                completionHandler(image, nil)
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, completionHandler: @escaping (NSImage?, Error?) -> ()) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, completionHandler: completionHandler)
//    }
//}

extension NSUserInterfaceItemIdentifier {
    static let collectionViewItem = NSUserInterfaceItemIdentifier("GalleryCollectionViewItem")
}
