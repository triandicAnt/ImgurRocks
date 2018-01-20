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
    func testAlamofireAPI()-> Void {
        print(Utils.CLIENT_ID)
        let parameters: Parameters = [
            "client_id": Utils.CLIENT_ID,
            "client_secret": Utils.CLIENT_SECRET,
        ]
        Alamofire.request("https://api.imgur.com/3/account/triandicant", method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
