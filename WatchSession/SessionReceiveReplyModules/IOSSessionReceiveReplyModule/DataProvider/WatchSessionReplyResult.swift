//
//  WatchSessionReplyDataProviderResult.swift
//  IOSQuiz
//
//  Created by galushka on 7/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum WatchSessionDataFailure: String {
    case unauthorized = "unauthorized"
    
    case noInternetConnection = "noInternetConnection"
    case noServerConnection = "noServerConnection"
    
    case unknown = "unknown"
}

enum WatchSessionReplyDataProviderResult<T> {
    case Success(T)
    case Failure(WatchSessionDataFailure)
}
