//
//  WatchSessionDataParcer.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum WatchSessionDataParcerError: Error {
    case emptyDictionary
    case invalidDictionary
    case cantUnarchive
}

struct WatchSessionDataParser: WatchSessionDataParserType {
    
    func requestType(from message: [String: Any]) -> WatchSessionDataRequestKey? {
        guard let requestTypeString = message["request"] as? String else { return nil }
        
        return WatchSessionDataRequestKey(rawValue: requestTypeString)
    }
    
    func dataType(from message: [String: Any]) -> WatchSessionDataKey? {
        guard let dataDictionary = message["data"] as? [String: Any] else {
            return nil
        }
        
        for (key, _) in dataDictionary {
            if let dataType = WatchSessionDataKey(rawValue: key) {
                return dataType
            }
        }
        
        return nil
    }
    
    func categories(from message: [String: Any]) -> WatchSessionReplyDataProviderResult<[QuizTestCategory]> {
        let categoriesResult = dataModels(from: message, dataType: WatchSessionDataKey.categories, modelType: QuizTestCategory.self)
        return categoriesResult
    }
    
    func questions(from message: [String: Any]) -> WatchSessionReplyDataProviderResult<[QuizTestQuestion]> {
        let questionsResult = dataModels(from: message, dataType: WatchSessionDataKey.questions, modelType: QuizTestQuestion.self)
        return questionsResult
    }
    
    func histories(from message: [String: Any]) -> WatchSessionReplyDataProviderResult<[QuizTestHistory]> {
        let historiesResult = dataModels(from: message, dataType: WatchSessionDataKey.histories, modelType: QuizTestHistory.self)
        return historiesResult
    } 
    
    // MARK: WHATS WRONG WITH GENERICS!!!
    func dataModels<ModelType: Codable>(from message: [String: Any], dataType: WatchSessionDataKey, modelType: ModelType.Type) -> WatchSessionReplyDataProviderResult<[ModelType]> {
        if let categoriesDatas = data(from: message, dataType: dataType) {
            
            let dataModels: [ModelType] = categoriesDatas.map { decode(data: $0) }.flatMap{$0}
            
            if dataModels.count > 0 {
                return WatchSessionReplyDataProviderResult.Success(dataModels)
            } else {
                return WatchSessionReplyDataProviderResult.Failure(WatchSessionDataFailure.unknown)
            }
        }
        
        return WatchSessionReplyDataProviderResult.Failure(error(from: message))
    }
    
    func data(from message: [String: Any], dataType: WatchSessionDataKey) -> [Data]? {
        guard
            let dataDictionary = message["data"] as? [String: Any],
            let data = dataDictionary[dataType.rawValue] as? [Data]
            else {
                return nil
        }
        
        return data
    }
    
    func isMessageEmpty(_ message: [String: Any]) -> Bool {
        return message.isEmpty
    }
    
    func error(from message: [String: Any]) -> WatchSessionDataFailure {
        guard
            let errorName = message["error"] as? String,
            let watchSessionDataFailure = WatchSessionDataFailure(rawValue: errorName)
            else {
                return WatchSessionDataFailure.unknown
        }
        
        return watchSessionDataFailure
    }
    
    func historiesPostModel(from message: [String: Any]) -> [QuizPostHistoryModel] {
        guard
            let dataDictionary = message["data"] as? [String: Any],
            let historiesPostModelDatas = dataDictionary[WatchSessionDataKey.histories.rawValue] as? [Data]
        else { return [] }
        
        let historyPostModels = historiesPostModelDatas.map {(data) -> QuizPostHistoryModel? in
            guard let historyPostModel: QuizPostHistoryModel = self.decode(data: data) else {
                return nil
            }
            
            return historyPostModel
            }.flatMap{$0}
        
        return historyPostModels
    }
    
    func decode<T: Codable>(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension WatchSessionDataParser {

    func questionsRequestParams(from message: [String: Any]) -> QuestionRequestParams? {
        guard
            let dataDictionary = message["data"] as? [String: [String: Any]],
            let questionDictionary = dataDictionary[WatchSessionDataKey.questions.rawValue]
            else {
                return nil
        }
        
        guard
            let categoryID = questionDictionary[QuestionRequestKey.categoryID.rawValue] as? String,
            let offset = questionDictionary[QuestionRequestKey.offset.rawValue] as? Int,
            let pageSize = questionDictionary[QuestionRequestKey.pageSize.rawValue] as? Int
            else {
                return nil
        }
        
        let requestParams = QuestionRequestParams(categoryID: categoryID,
                                                  offset: offset,
                                                  pageSize: pageSize)
        
        return requestParams
    }
}
