//
//  GalleryViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/24/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class GalleryViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var tagsButton :NSButton!
    @IBOutlet weak var matureButton: NSButton!
    @IBOutlet weak var viralButton: NSButton!
    @IBOutlet weak var sectionBox: NSBox!
    @IBOutlet weak var sortBox: NSBox!

    var sortString:String!
    var sectionString:String!

    let apiManager = APIManager()
    var galleryPosts : [GalleryPost] = [GalleryPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor(hex: "309f98").cgColor
        self.view.wantsLayer = true
        self.tagsButton.layer?.backgroundColor = NSColor(hex: "FFFFFF").cgColor
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


        configureCollectionView()
        authenticateAPI()
    }
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 300.0, height: 300.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        //        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        collectionView.layer?.backgroundColor = NSColor(hex: "414a4c").cgColor
    }
    
    @IBAction func loadTags(sender: NSButton) {
        let animator = MyCustomSwiftAnimator()
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let destinationViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "tags")) as! NSViewController
        self.presentViewController(destinationViewController, animator: animator)
    }
    
    @IBAction func sortBy(sender: NSButton) {
        sortString = sender.title.lowercased()
    }
    @IBAction func sectionBy(sender: NSButton) {
        sectionString = sender.title.lowercased()
    }
    func authenticateAPI(tagName :String = "funny") {
        let tagUrl = Utils.GALLERY_TAG_URL + tagName + "/" + self.sortString + "/1"
        apiManager.fetchGalleryAPIImages(tagName: tagUrl, mature: self.matureButton.state.rawValue, viral: self.viralButton.state.rawValue) { responseObject, error in
            self.processData(data: responseObject!) {posts,error in
                self.collectionView.reloadData()
            }
        }
    }
    
    func processData (data: Data, completionHandler: @escaping ([Any]?, NSError?) -> ()) {
        do {
            if let jsonVal = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                let jsonValueData:[String : Any] = (jsonVal["data"] as? [String : Any])!
                let items:[Any] = (jsonValueData["items"] as? [Any])!
                for item in items {
                    let post:[String:Any] = item as! [String : Any]
                    let title:String = (post["title"] as? String)!
                    var imageArray : [NSImage] = [NSImage]()
                    if let imageFiles = post["images"] {
                        let imgDict:[Any] = (imageFiles as? [Any])!
                        for image in imgDict {
                            let img:[String:Any] = image as! [String : Any]
                            let imgUrl:String = img["link"] as! String
                            let url = URL(string: imgUrl)
                            let fileExt = NSURL(fileURLWithPath: imgUrl).pathExtension
                            if !["mp4", "gif", "gifv"].contains(fileExt!) {
                                if let data = try? Data(contentsOf: url!){
                                    imageArray.append(NSImage(data: data)!)
                                }
                            } else if fileExt == "gif" {
                                imageArray.append(NSImage(byReferencing: url!))
                            }
                        }
                    }
                    else if let imageFiles = post["gifv"] {
                        let imgUrl:String = imageFiles as! String
                        let url = URL(string: imgUrl)
                        imageArray.append(NSImage(byReferencing: url!))
                    }
                    if imageArray.count > 0 {
                        let galleryPost: GalleryPost = GalleryPost(homeImage: imageArray[0], title: title, images: imageArray)!
                        self.galleryPosts.append(galleryPost)
                        completionHandler(self.galleryPosts, nil)
                    }
                }
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
//        collectionViewItem.imageView?.image = post.homeImage
//        collectionViewItem.title = post.title
        let imageFile = ImageFile(thumbnail: post.homeImage!, fileName: post.title!)
        collectionViewItem.imageFile = imageFile
        let galleryImgView = collectionViewItem.imageView as! GalleryImageView
        galleryImgView.index = indexPath.item
        return item
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
