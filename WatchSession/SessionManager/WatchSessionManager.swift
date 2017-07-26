//
//  WatchSessionManager.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate, WatchSessionManagerType {
    
    var isReachable: Bool {
        return session?.isReachable ?? false
    }
    
    static let shared = WatchSessionManager()
    
    var replyHandlerFromMessage: (([String : Any], @escaping ([String : Any]) -> Void) -> Void)? = nil
    var replyHandlerFromData: ((_ receivedData: Data) -> Data)? = nil
    
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        #if os(iOS)
            if let session = session,
                session.isPaired && session.isWatchAppInstalled {
                return session
            }
            return nil
        #elseif os(watchOS)
            return session
        #else
            return nil
        #endif
    }
    
    func start() {
        session?.delegate = self
        session?.activate()
    }
}

extension WatchSessionManager {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

// Send
extension WatchSessionManager {
    func sendMessage(_ message: [String: Any],
                     replyHandler: ((_ data: [String: Any]) -> Void)?,
                     errorHandler: ((Error) -> Void)?) {
        validSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func sendMessageData(_ data: Data,
                         replyHandler: ((_ data: Data) -> Void)?,
                         errorHandler: ((Error) -> Void)?) {
        validSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func sendMessage() {
        
    }
}

// Did Receive
extension WatchSessionManager {
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
    }
}

extension WatchSessionManager {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        
        if let fetchedReplyHandler = replyHandlerFromMessage {
            fetchedReplyHandler(message, { (data) in
                replyHandler(data)
            })
        } else {
            replyHandler([:])
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
        if let fetchedReplyHandler = replyHandlerFromData {
            let replyMessage = fetchedReplyHandler(messageData)
            replyHandler(replyMessage)
        } else {
            replyHandler(Data())
        }
    }
}
