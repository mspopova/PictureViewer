//
//  PhotoModel.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation
import  SwiftyJSON

struct Photo {
    var bigImageURL: String
    var title: String
    var owner: String
    var dateUpload: String
    var image: Data?
    
    init?(json: JSON) {
        guard let urlZ = json["url_z"].string,
              let title = json["title"].string,
              let owner = json["ownername"].string,
              let dateUp = json["dateupload"].string
            else {
                return nil
        }
        let date = Date(timeIntervalSinceReferenceDate: Double(dateUp)!)

        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateFormatted = dateFormatter.string(from: date)
        
        self.bigImageURL = urlZ
        self.owner = owner
        self.title = title
        self.dateUpload = dateFormatted
    }
}
