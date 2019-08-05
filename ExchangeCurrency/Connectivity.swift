//
//  Connectivity.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/27/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity{
    class var isConnectedToInternet : Bool{
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}

