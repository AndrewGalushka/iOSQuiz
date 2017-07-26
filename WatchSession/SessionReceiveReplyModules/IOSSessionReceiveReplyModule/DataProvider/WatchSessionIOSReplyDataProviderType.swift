//
//  WathSessionIOSDataProvider.swift
//  IOSQuiz
//
//  Created by galushka on 7/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WatchSessionIOSReplyDataProviderType {
    var token: String? { get }
    func requestType(from message: [String: Any]) -> WatchSessionDataRequestKey?
    func dataType(from message: [String: Any]) -> WatchSessionDataKey?
    func isUserLogIn(resultClosure: @escaping (_ result: Bool) -> Void)
    func categoriesReplyDictionary(resultClosure: @escaping (_ result: [String: Any]) -> Void)
    func questionReplyDictionary(from message: [String: Any], resultClosure: @escaping (_ result: [String: Any]) -> Void)
    func historiesReplyDictionary(from message: [String: Any], resultClosure: @escaping (_ result: [String: Any]) -> Void)
    
    func postHistory(from message: [String: Any])
}
