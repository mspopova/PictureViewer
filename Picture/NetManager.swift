//
//  NetManager.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetManager {
    
     func fetchFlickrPhotos(page: Int,completion: (([Photo]?) -> Void)? = nil) {
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
        let congiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: congiguration)
        let urlString = "https://api.flickr.com/services/rest/?method=\(parameters["method"]!)&api_key=\(parameters["api_key"]!)&sort=\(parameters["sort"]!)&per_page=\(parameters["per_page"]!)&format=\(parameters["format"]!)&nojsoncallback=\(parameters["nojsoncallback"]!)&extras=\(parameters["extras"]!)&page=\(parameters["page"]!)"
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url){
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data,
                  let json = try? JSON(data: data)
                else {
                    print("Error while parsing Flickr response")
                    completion?(nil)
                    return
            }
            let photosJSON = json["photos"]["photo"]
                let photos = photosJSON.arrayValue.compactMap { Photo(json: $0)}
                completion?(photos)
    }
        task.resume()
    }
}
