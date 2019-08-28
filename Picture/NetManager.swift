//
//  NetManager.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

class NetManager {
    
    static func fetchFlickrPhotos(page: Int,completion: (([Photo]?) -> Void)? = nil) {
    let url = URL(string: "https://api.flickr.com/services/rest/")!
    let parameters = [
        "method" : "flickr.interestingness.getList",
        "api_key" : "86997f23273f5a518b027e2c8c019b0f",
        "sort": "relevance",
        "per_page" : "20",
        "format" : "json",
        "nojsoncallback" : "1",
        "extras": "url_q,url_z,description,date_upload,date_taken,owner_name",
        "page": "\(page)"
    ]
    
    Alamofire.request(url, method: .get, parameters: parameters)
        .validate()
        .responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                guard let data = response.data, let json = try? JSON(data: data) else {
                    print("Error while parsing Flickr response")
                    completion?(nil)
                    return
                }
                let photosJSON = json["photos"]["photo"]
                let photos = photosJSON.arrayValue.compactMap { Photo(json: $0)}
//                    for photo in photos {
//                        let url = URL(string: photo.bigImageURL)
//                        KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
//                        if let data = image?.pngData(){
//                            photo.image = data
//                        }
//                    })
//                }
                completion?(photos)
                
            case .failure(let error):
                print("Error while fetching photos: \(error.localizedDescription)")
                completion?(nil)
            }
    }
}
}
