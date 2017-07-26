//
//  WCReceiveModule.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class WatchSessionIOSReceiveReplyModule: WatchSessionReceiveReplyModuleBaseType {
    private let wcSessionManager: WatchSessionManagerType
    private let replyDataProvider: WatchSessionIOSReplyDataProviderType
    
    init(sessionManager: WatchSessionManagerType, replyDataProvider: WatchSessionIOSReplyDataProviderType) {
        wcSessionManager = sessionManager
        self.replyDataProvider = replyDataProvider
        
        wcSessionManager.replyHandlerFromMessage = replyHandlerToSessionMessageRecieving
    }
    
    func startSession() {
        wcSessionManager.start()
    }
    
    private var replyHandlerToSessionMessageRecieving: (([String : Any], @escaping ([String : Any]) -> Void) -> Void) {
        return {  [weak self] (receivedMessage, resultClosure) in
            
            guard
                let strongSelf = self,
                let requestType = strongSelf.replyDataProvider.requestType(from: receivedMessage)
            else {
                    resultClosure([:])
                    return
            }
            
            guard let dataType = strongSelf.replyDataProvider.dataType(from: receivedMessage) else {
                resultClosure([:])
                return
            }
            
            switch requestType {
            case .get:
                
                switch dataType {
                case .categories:
                    strongSelf.replyDataProvider.categoriesReplyDictionary(resultClosure: { (replyDictionary) in
                        resultClosure(replyDictionary)
                    })
                case .histories:
                    strongSelf.replyDataProvider.historiesReplyDictionary(from: receivedMessage, resultClosure: { (replyDictionary) in
                        resultClosure(replyDictionary)
                    })
                case .questions:
                    strongSelf.replyDataProvider.questionReplyDictionary(from: receivedMessage, resultClosure: { (replyDictionary) in
                        resultClosure(replyDictionary)
                    })
                case .token:
                    resultClosure(["data": strongSelf.replyDataProvider.token ?? "error"])
                }
                
            case .post:
                switch dataType {
                case .histories:
                    strongSelf.replyDataProvider.postHistory(from: receivedMessage)
                    resultClosure([:])
                default:
                    break
                }
            }
        }
    }
    
    private let replyHandlerToSessionMessageDataRecieving: ((_ receivedData: Data) -> Data) = { (receivedMessage) -> Data in
        return Data()
    }
}

