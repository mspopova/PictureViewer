//
//  Connectivity.swift
//  Picture
//
//  Created by Марина Попова on 28/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//
import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
