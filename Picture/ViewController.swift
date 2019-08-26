//
//  ViewController.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import MBProgressHUD


class ViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFlickrPhotos()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pictureViewController = segue.destination as? PictureViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            pictureViewController.photo = photos[indexPath.row]
        }
    }


}

// MARK: - UICollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo = photos[indexPath.row]
        cell.imageURL = photo.bigImageURL
        cell.ownerLabel.text = "by \(photo.owner)"
        cell.titleLabel.text = photo.title
        
    
        
        
        return cell
    }
    
 }

//MARK: - progress notiiocation
extension ViewController {
    func getFlickrPhotos() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        NetManager.fetchFlickrPhotos() { [weak self] photos in
            guard let selfie = self else { return }
            MBProgressHUD.hide(for: selfie.view, animated: true)
            
            if let photos = photos {
                selfie.photos = photos
                selfie.collectionView.reloadData()
            }
        }
    }
}
