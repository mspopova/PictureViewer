//
//  ViewController.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import MBProgressHUD
import Kingfisher
import RealmSwift


class ViewController: UIViewController {
    static var checkedConnection = false
    var isConnected = checkedConnection
    
    var photosBD: Results<Photo>!
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var fetchingMore = false
    
    
    var photos = [Photo]()
    let cache = ImageCache.default

    override func viewDidLoad() {
        super.viewDidLoad()
        if !ViewController.checkedConnection {
            navigationItem.title = ("Pictures (offline)")
        } else {
            navigationItem.title = ("Pictures Daily")
        }
        
        photosBD = realm.objects(Photo.self)
        
        cache.maxCachePeriodInSecond = -1
        cache.maxDiskCacheSize = 500*1024*1024
        
        getFlickrPhotos()
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pictureViewController = segue.destination as? PictureViewController,
            let indexPath = tableView.indexPathsForSelectedRows?.first {
            pictureViewController.isConnected = isConnected
            if isConnected{
                pictureViewController.photo = photos[indexPath.row]
            } else {
                pictureViewController.photo = photosBD[indexPath.row]
            }
        }
    }
}

// MARK: - UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if isConnected{
            numberOfRows = photos.count
        } else {
            numberOfRows = photosBD.count
        }
       return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isConnected {
            //print("we are here tableview called online")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoCell
            let photo = photos[indexPath.row]
            cell.imageURL = photo.bigImageURL
            cell.ownerLabel.text = "by \(photo.owner)"
            cell.nameLabel.text = photo.title
            return cell
        } else {
            //print("we are here tableview called offline")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoCell
            let photoBD = photosBD[indexPath.row]
            let image = load(fileName: photoBD.bigImageURL)
            cell.photoImageView.image = image
            cell.ownerLabel.text = "by \(photoBD.owner)"
            cell.nameLabel.text = photoBD.title
            return cell
        }
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        //print ("\(offsetY), contentHeight: \(contentHeight), phone: \(scrollView.frame.height), razn = \(contentHeight-offsetY)")
        if contentHeight - offsetY <= scrollView.frame.height*1.5{
            if !fetchingMore {
                beginBatchFetch()
            }
            
        }
    }
    
    func beginBatchFetch() {
        print(isConnected)
        if !isConnected{
            return
        }
        fetchingMore = true
      //  print("beginBatchFetch!")
        DispatchQueue.main.async( execute: {
            self.getMoreFlickrPhotos()
            self.fetchingMore = false
        })
    }
 }

//MARK: - progress notification
extension ViewController {
    func getFlickrPhotos() {
        if Connectivity.isConnectedToInternet {
      //      print("Yes! internet is available.")
            isConnected = true
            StorageManager.deleteAll()
        } else {
            isConnected = false
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        NetManager.fetchFlickrPhotos(page: page) { [weak self] photos in
            guard let selfie = self else { return }
            MBProgressHUD.hide(for: selfie.view, animated: true)
            self!.page += 1
            if let photos = photos {
                selfie.photos = photos
                for photo in selfie.photos {
                    StorageManager.saveObject(photo)
                }
                selfie.tableView.reloadData()
            }
        }
    }
    func getMoreFlickrPhotos(){
        if Connectivity.isConnectedToInternet {
        //    print("Yes! internet is available.")
            isConnected = true
        } else {
            isConnected = false
            
        }
        MBProgressHUD.showAdded(to: view, animated: true)
            NetManager.fetchFlickrPhotos(page: page) { [weak self] photos in
                guard let selfie = self else { return }
                MBProgressHUD.hide(for: selfie.view, animated: true)
                self!.page += 1
                if let photos = photos {
                    for photo in photos {
                        StorageManager.saveObject(photo)
                    }
                    selfie.photos.append(contentsOf: photos)
                    selfie.tableView.reloadData()
                }
            }
    }
    
}
