//
//  PictureViewController.swift
//  Picture
//
//  Created by Марина Попова on 27/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    var photo: Photo?
    var isConnected: Bool?

    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let photo = photo {
            if let imageData = photo.imageData, let image = UIImage(data: imageData) {
                bigImageView.image = image
                }
            }
        
        let date = photo?.dateUpload
        dateLabel.text = "Upload date: \(date ?? "unknown")"
        

    }
}
