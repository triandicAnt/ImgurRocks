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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the Imgur API and fetch data
        configureCollectionView()
        authenticateAPI()
    }
    
    func authenticateAPI() {
        let apiManager = APIManager()
        //apiManager.testAlamofireAPI()
        apiManager.fetchGalleryAPIImages() { responseObject, error in
            self.processData(data: responseObject!)
        }
    }
    
    func processData (data: Data) {
        do {
            if let jsonVal = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                let jsonValueData:[String : Any] = (jsonVal["data"] as? [String : Any])!
                let tags: [Any] = (jsonValueData["tags"] as? [Any])!
                tagsArray = tags
                print(tags.count)
                let galleries: [Any] = (jsonValueData["galleries"] as? [Any])!
                galleryArray = galleries
                print(galleries.count)
                for tag in tags{
                    let t:[String:Any] = tag as! [String : Any]
                    //                        print((t["display_name"] as! String) + "  " + (t["name"] as! String))
                }
                print("---------------------")
                for gallery in galleries{
                    let g:[String:Any] = gallery as! [String : Any]
//                    print(g)
                }
            }
            collectionView.reloadData()
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

