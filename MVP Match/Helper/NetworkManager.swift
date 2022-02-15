//
//  NetworkManager.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/10/22.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
