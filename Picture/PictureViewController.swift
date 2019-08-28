//
//  PictureViewController.swift
//  Picture
//
//  Created by Марина Попова on 27/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import Kingfisher

class PictureViewController: UIViewController {
    var photo: Photo?
    var isConnected: Bool?
    let cache = ImageCache.default

    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if isConnected! {
            if let photo = photo, let url = URL(string: photo.bigImageURL) {
                bigImageView.kf.setImage(with: url)
            }
        }
        else {
            if let photo = photo {
            let image = load(fileName: photo.bigImageURL)
                bigImageView.image = image
                
            }
        }

        let date = photo?.dateUpload
        dateLabel.text = "Upload date: \(date ?? "unknown")"
        

}
    private func load(fileName: String) -> UIImage? {
        let urlStr = cache.cachePath(forComputedKey: fileName)
        let url = URL(fileURLWithPath: urlStr)
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
