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
    
    init?(json: JSON) {
        guard let urlZ = json["url_z"].string,
              let title = json["title"].string,
              let owner = json["ownername"].string
            else {
                return nil
        }
        
        self.bigImageURL = urlZ
        self.owner = owner
        self.title = title
    }
}
