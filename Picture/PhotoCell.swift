//
//  PhotoCell.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                photoImageView.kf.setImage(with: url)
            } else {
                photoImageView.image = nil
                photoImageView.kf.cancelDownloadTask()
            }
        }
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
}
