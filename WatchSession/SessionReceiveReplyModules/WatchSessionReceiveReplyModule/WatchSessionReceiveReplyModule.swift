//
//  WatchSessionReceiveReplyModule.swift
//  IOSQuiz
//
//  Created by galushka on 7/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchConnectivity

struct WatchSessionReceiveReplyModule: WatchSessionReceiveReplyModuleBaseType, WatchSessionReceiveReplyModuleType  {
    private var wcSessionManager: WatchSessionManagerType
    private var requestCollector: WatchSessionRequestCollectorType
    private let dataParser = WatchSessionDataParser()
    
    var isWCConnectionReachable: Bool {
        return wcSessionManager.isReachable
    }
    
    init(sessionManager: WatchSessionManagerType, sessionRequestCollector: WatchSessionRequestCollectorType) {
        wcSessionManager = sessionManager
        requestCollector = sessionRequestCollector
    }
    
    func startSession() {
        wcSessionManager.start()
    }
    
    private let errorHandler: ((Error) -> Void) = { (error) in
        let error = error as NSError
        print("Code: \(error.code), Description: \(error.description)")
    }
    
    func categories(resultClosure: @escaping (_ categoriesResult: WatchSessionReplyDataProviderResult<[QuizTestCategory]>) -> Void) {
        let requestDictionary = requestCollector.requestCategories()
        
        wcSessionManager.sendMessage(requestDictionary, replyHandler: { (replyMessage) in
            let categoriesResult = self.dataParser.categories(from: replyMessage)
            resultClosure(categoriesResult)
        }, errorHandler: errorHandler)
    }
    
    func questions(categoryID: String, offset: Int, pageSize: Int,
                   resultClosure: @escaping (_ questionsResult: WatchSessionReplyDataProviderResult<[QuizTestQuestion]>) -> Void) {
        let requestDictionary = requestCollector.requestQuestion(categoryID: categoryID, offset: offset, pageSize: pageSize)
        
        wcSessionManager.sendMessage(requestDictionary, replyHandler: { (replyMessage) in
            let questionsResult = self.dataParser.questions(from: replyMessage)
            resultClosure(questionsResult)
        }, errorHandler: errorHandler)
    }
    
    func histories(resultClosure: @escaping (_ categoriesResult: WatchSessionReplyDataProviderResult<[QuizTestHistory]>) -> Void) {
        let requestDictionary = requestCollector.requestHistories()
        
        wcSessionManager.sendMessage(requestDictionary, replyHandler: { (replyMessage) in
            let historiesResult = self.dataParser.histories(from: replyMessage)
            resultClosure(historiesResult)
        }, errorHandler: errorHandler)
    }
    
    func postHistory(historyPostModel: QuizPostHistoryModel) {
        guard let requestDictionary = requestCollector.requestPostHistory(historyPostData: historyPostModel) else { return }
        
        wcSessionManager.sendMessage(requestDictionary, replyHandler: { (message) in
            print("message")
        }, errorHandler: { (error) in
            let error = error as NSError
            
            print("errorCode:\(error.code), description:\(error.description)")
        })
    }
    
}
