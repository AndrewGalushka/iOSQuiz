//
//  WatchSessionRequestCollector.swift
//  IOSQuiz
//
//  Created by galushka on 7/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct WatchSessionRequestCollector: WatchSessionRequestCollectorType {
    
    func requestPostHistory(historyPostData history: QuizPostHistoryModel) -> [String : Any]? {
        guard let dataHistory = encode(data: history) else { return nil }
        let historyDataDictionary = [WatchSessionDataKey.histories.rawValue: [dataHistory]]
        
        let finalDictionary = ["request": "post",
                               "data": historyDataDictionary] as [String: Any]
        
        return finalDictionary
    }
    
    func requestQuestion(categoryID: String, offset: Int, pageSize: Int) -> [String: Any] {
        
        let questionRequestParamsDictionary = [QuestionRequestKey.categoryID.rawValue: categoryID,
                                               QuestionRequestKey.offset.rawValue: offset,
                                               QuestionRequestKey.pageSize.rawValue: pageSize] as [String : Any]
        let questionDictionary = [WatchSessionDataKey.questions.rawValue: questionRequestParamsDictionary]
        let finalDictionary = ["request": "get",
                               "data": questionDictionary] as [String: Any]
        
        return finalDictionary
    }
    
    func requestCategories() -> [String: Any] {
        let categoriesDictionary = [WatchSessionDataKey.categories.rawValue: ""]
        
        let finalDictionary = ["request": "get",
                               "data": categoriesDictionary] as [String: Any]
        
        return finalDictionary
    }
    
    func requestHistories() -> [String: Any] {
        let historiesDictionary = [WatchSessionDataKey.histories.rawValue: ""]
        
        let finalDictionary = ["request": "get",
                               "data": historiesDictionary] as [String: Any]
        
        return finalDictionary
    }
    
    func encode<T: Codable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}
