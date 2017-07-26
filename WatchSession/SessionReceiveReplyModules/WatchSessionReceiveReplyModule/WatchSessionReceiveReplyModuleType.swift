//
//  WatchSessionReceiveReplyModuleType.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WatchSessionReceiveReplyModuleType {
    var isWCConnectionReachable: Bool { get }
    
    func startSession()
    func categories(resultClosure: @escaping (_ categoriesResult: WatchSessionReplyDataProviderResult<[QuizTestCategory]>) -> Void)
    func questions(categoryID: String, offset: Int, pageSize: Int,
                   resultClosure: @escaping (_ questionsResult: WatchSessionReplyDataProviderResult<[QuizTestQuestion]>) -> Void)
    func histories(resultClosure: @escaping (_ categoriesResult: WatchSessionReplyDataProviderResult<[QuizTestHistory]>) -> Void)
    func postHistory(historyPostModel: QuizPostHistoryModel)
}
