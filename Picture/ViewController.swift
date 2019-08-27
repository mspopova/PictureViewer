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
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var fetchingMore = false
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFlickrPhotos()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pictureViewController = segue.destination as? PictureViewController,
            let indexPath = tableView.indexPathsForSelectedRows?.first {
            pictureViewController.photo = photos[indexPath.row]
        }
    }
}

// MARK: - UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageURL = photo.bigImageURL
        cell.ownerLabel.text = "by \(photo.owner)"
        cell.nameLabel.text = photo.title
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if contentHeight - offsetY == scrollView.frame.height{
            if !fetchingMore {
                beginBatchFetch()
            }

        }
    }
    func beginBatchFetch() {
        fetchingMore = true
        print("beginBatchFetch!")
        DispatchQueue.main.async( execute: {
            self.getMoreFlickrPhotos()
            self.fetchingMore = false
        })
    }
 }

//MARK: - progress notification
extension ViewController {
    func getFlickrPhotos() {
        MBProgressHUD.showAdded(to: view, animated: true)
        NetManager.fetchFlickrPhotos(page: page) { [weak self] photos in
            guard let selfie = self else { return }
            MBProgressHUD.hide(for: selfie.view, animated: true)
            self!.page += 1
            if let photos = photos {
                selfie.photos = photos
                selfie.tableView.reloadData()
            }
        }
    }
    func getMoreFlickrPhotos(){
        MBProgressHUD.showAdded(to: view, animated: true)
        NetManager.fetchFlickrPhotos(page: page) { [weak self] photos in
            guard let selfie = self else { return }
            MBProgressHUD.hide(for: selfie.view, animated: true)
            self!.page += 1
            if let photos = photos {
                selfie.photos.append(contentsOf: photos)
                selfie.tableView.reloadData()
            }
        }
    }
}
