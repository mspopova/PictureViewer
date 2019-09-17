//
//  ViewController.swift
//  Picture
//
//  Created by Марина Попова on 26/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift
import Network


class ViewController: UIViewController {
    
    var isConnected = true
    
    var photos: Results<Photo>!
    var page = 1
    var fetchingMore = false
    
    let storageManager = StorageManager()
    let netManager = NetManager()
    let monitor = NWPathMonitor()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                self.isConnected = true
                if self.page == 1 {
                    self.getFlickrPhotos(more: false)
                } else {
                    self.getFlickrPhotos(more: true)
                }
            } else {
                self.alert(message: "You're offline", title: "Connection lost")
                self.isConnected = false
                print("No connection")
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)

        photos = realm.objects(Photo.self)
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pictureViewController = segue.destination as? PictureViewController,
            let indexPath = tableView.indexPathsForSelectedRows?.first {
          //  pictureViewController.isConnected = isConnected
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
        if let imageData = photo.imageData, let image = UIImage(data: imageData) {
            cell.photoImageView.image = image
        }
            cell.ownerLabel.text = "by \(photo.owner)"
            cell.nameLabel.text = photo.title
            return cell
        }
 }

//MARK: - getting photos
extension ViewController {
    
    func beginBatchFetch() {
        if !isConnected{
            return
        }
        fetchingMore = true
        DispatchQueue.main.async( execute: {
            self.getFlickrPhotos(more: true)
            self.fetchingMore = false
        })
    }
    
    func getFlickrPhotos(more: Bool) {
        if isConnected {
            if !more{
                storageManager.deleteAll()}
        } else {
            return
        }
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)}
        DispatchQueue.global().async {
            self.netManager.fetchFlickrPhotos(page: self.page) { [weak self] photos in
                guard let selfie = self else { return }
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: selfie.view, animated: true)
                    self!.page += 1
                    if let photos = photos {
                        selfie.storageManager.saveObjects(photos)
                        selfie.tableView.reloadData()
                    }
                }
            }
        }

    }
    
// MARK: - scrollView
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
    
// MARK: - alert
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async  {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}


