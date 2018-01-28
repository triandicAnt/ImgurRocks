//
//  APIManager.swift
//  ImgurRocks
//
//  Created by Sudhansu Singh on 1/20/18.
//  Copyright © 2018 Sudhansu Singh. All rights reserved.
//

import Foundation
import Alamofire
class APIManager: NSObject {
    func testAlamofireAPI(completionHandler: @escaping (Data?, NSError?) -> ())-> Void {
        print(Utils.CLIENT_ID)
        let parameters: Parameters = [
            "client_id": Utils.CLIENT_ID,
            "client_secret": Utils.CLIENT_SECRET,
        ]
        fireIntheHole(parameters: parameters, urlString: Utils.MY_URL, completionHandler: completionHandler)
    }
    
    func fetchGalleryAPIImages(tagName: String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        print("fetch gallery is being called")
        // {"showViral":"true","mature":"true","album_previews":"true"}
        let parameters: Parameters = [
            "client_id": Utils.CLIENT_ID,
            "client_secret": Utils.CLIENT_SECRET,
            "showViral":true,
            "mature":true,
            "album_previews": true,
        ]
        fireIntheHole(parameters: parameters, urlString: tagName, completionHandler: completionHandler)
    }
    
    func fetchImageDataForHash(hash:String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let parameters: Parameters = [
            "client_id": Utils.CLIENT_ID,
            "client_secret": Utils.CLIENT_SECRET,
            "mature":true,
            ]
        fireIntheHole(parameters: parameters, urlString: Utils.IMAGE_URL+hash, completionHandler: completionHandler)
    }
    
    
    /// This function fetches data from Gallery endpoint
    ///
    /// - Parameter parameters: Parameters passed to the GET request.
    
    func fireIntheHole(parameters:Parameters, urlString:String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { response in
//            if let json = response.result.value {
////                print("JSON: \(type(of: json))") // serialized json response
//            }
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
////                print(type(of: data))
//            }
            completionHandler(response.data, nil)
        }
    }
}
