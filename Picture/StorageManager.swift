//
//  StorageManager.swift
//  Picture
//
//  Created by Марина Попова on 28/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
     func saveObjects (_ photos: [Photo]) {
        try! realm.write {
            realm.add(photos)
        }
    }
    
     func deleteAll(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
