//
//  WatchSessionManagerType.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchConnectivity

protocol WatchSessionManagerType where Self: WCSessionDelegate {
    
    var replyHandlerFromMessage: ((_ receivedMessage: [String : Any], _ result: @escaping (_ data:[String: Any]) -> Void) -> Void)? {get set}
    var replyHandlerFromData: ((_ receivedData: Data) -> Data)? {get set}
    
    func start()
    func sendMessage(_ message: [String: Any],
                     replyHandler: ((_ data: [String: Any]) -> Void)?,
                     errorHandler: ((Error) -> Void)?)
    func sendMessageData(_ data: Data,
                         replyHandler: ((_ data: Data) -> Void)?,
                         errorHandler: ((Error) -> Void)?)
    
    var isReachable: Bool { get }
}
