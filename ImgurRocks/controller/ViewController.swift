//
//  ViewController.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/18/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!
    var tagsArray:[Any] = [Any] ()
    var galleryArray:[Any] = [Any] ()
    var tagsImageArray:[URL] = [URL] ()
    var galleryImageURL:[URL] = [URL] ()
    let apiManager = APIManager()

    
    override func viewDidLoad() {
        print("old view controller being called")
        super.viewDidLoad()
        // Call the Imgur API and fetch data
        configureCollectionView()
        authenticateAPI()
    }
    
    func authenticateAPI() {
        //apiManager.testAlamofireAPI()
        apiManager.fetchGalleryAPIImages() { responseObject, error in
            self.processData(data: responseObject!) {tags,galleries,error in
//                self.fetchTagImages(tags: tags!) { tagImages, error in
//                    print(tagImages)
                    self.collectionView.reloadData()
//                }
            }
        }
    }

    func fetchTagImages(tags: [Any], completionHandler: @escaping ([URL], NSError?) -> ()) {
        let myGroup = DispatchGroup()
        for tag in tags{
            print(tag)
            let t:[String:Any] = tag as! [String : Any]
            let bgHash = t["background_hash"] as! String
            myGroup.enter()
            self.apiManager.fetchImageDataForHash(hash: bgHash) { responseObject, error in
                do {
                    if let imgData = try JSONSerialization.jsonObject(with: responseObject!, options:.allowFragments) as? [String:Any] {
                        print(imgData)
                        let imgValueData:[String : Any] = (imgData["data"] as? [String : Any])!
                        self.tagsImageArray.append(NSURL(string: (imgValueData["link"] as! String))! as URL)
                        myGroup.leave()
                    }
                }  catch let err{
                    print(err.localizedDescription)
                }
            }
        }
        myGroup.notify(queue: DispatchQueue.main) {
//            print(self.tagsImageArray)
            completionHandler(self.tagsImageArray, nil)
        }
    }
    
    func processData (data: Data, completionHandler: @escaping ([Any]?, [Any]?, NSError?) -> ()) {
        do {
            if let jsonVal = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                let jsonValueData:[String : Any] = (jsonVal["data"] as? [String : Any])!
                let tags: [Any] = (jsonValueData["tags"] as? [Any])!
                tagsArray = tags
                print(tags.count)
                let galleries: [Any] = (jsonValueData["galleries"] as? [Any])!
                galleryArray = galleries
                print(galleries.count)
                print("---------------------")
                completionHandler(tagsArray, galleryArray, nil)
            }
        } catch let err{
            print(err.localizedDescription)
        }
    }

    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
//        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        collectionView.layer?.backgroundColor = NSColor(hex: "414a4c").cgColor
    }
    
}
extension ViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return galleryArray.count
        } else {
            return tagsArray.count
        }
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        if indexPath.section == 0 {
            let g:[String:Any] = galleryArray[indexPath.item] as! [String : Any]
            let desc: String = (g["name"] as! String)
            if let image = NSImage(named: NSImage.Name(rawValue: "gallery"))
            {
                let imageFile = ImageFile(thumbnail: image, fileName: desc)
                collectionViewItem.imageFile = imageFile
            }

        } else {
            let t:[String:Any] = tagsArray[indexPath.item] as! [String : Any]
            let desc: String = (t["display_name"] as! String)
            if let image = NSImage(named: NSImage.Name(rawValue: "blur"))
            {
                let imageFile = ImageFile(thumbnail: image, fileName: desc)
                collectionViewItem.imageFile = imageFile
            }
//            do {
//                if let image = try NSImage(data: Data(contentsOf: self.tagsImageArray[indexPath.item])){
//                    let imageFile = ImageFile(thumbnail: image, fileName: desc)
//                    collectionViewItem.imageFile = imageFile
//                }
//            }  catch let err{
//                print(err.localizedDescription)
//            }

        }
        return item
    }
}

extension ViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSZeroSize
    }
}

extension NSColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

