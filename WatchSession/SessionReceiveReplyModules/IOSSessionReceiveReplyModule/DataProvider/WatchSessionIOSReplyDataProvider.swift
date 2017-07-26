//
//  WatchSessionIOSDataProvider.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct WatchSessionIOSReplyDataProvider: WatchSessionIOSReplyDataProviderType {
    typealias DataProviderResult = WatchSessionReplyDataProviderResult
    
    private let serverManager: QuizServerManagerType
    private let messageDataParser: WatchSessionDataParserType
    
    init(serverManager: QuizServerManagerType, dataParser: WatchSessionDataParserType) {
        self.serverManager = serverManager
        self.messageDataParser = dataParser
    }
    
    var token: String? {
        return serverManager.token
    }
    
    func requestType(from message: [String : Any]) -> WatchSessionDataRequestKey? {
        return messageDataParser.requestType(from: message)
    }
    
    func dataType(from message: [String: Any]) -> WatchSessionDataKey? {
        return messageDataParser.dataType(from: message)
    }
    
    func isUserLogIn(resultClosure: @escaping (_ result: Bool) -> Void) {
        serverManager.isUserTokenValid { (result) in
            resultClosure(result)
        }
    }
    
    func categoriesReplyDictionary(resultClosure: @escaping (_ result: [String: Any]) -> Void) {
        categoriesData { (dataProviderResult) in
            let replyDictionary = self.makeReplyDictionary(from: dataProviderResult, dataType: .categories)
            resultClosure(replyDictionary)
        }
    }
    
    func questionReplyDictionary(from message: [String: Any], resultClosure: @escaping (_ result: [String: Any]) -> Void) {
        questionsData(fromMessageRequest: message) { (dataProviderResult) in
            let replyDictionary = self.makeReplyDictionary(from: dataProviderResult, dataType: .questions)
            resultClosure(replyDictionary)
        }
    }
    
    func historiesReplyDictionary(from message: [String: Any], resultClosure: @escaping (_ result: [String: Any]) -> Void) {
        historiesData { (historiesDataResult) in
            let replyDictionary = self.makeReplyDictionary(from: historiesDataResult, dataType: .histories)
            resultClosure(replyDictionary)
        }
    }
    
    func postHistory(from message: [String: Any]) {
        let historyPostModels = messageDataParser.historiesPostModel(from: message)
        
        if historyPostModels.isEmpty {
            return
        }
        
        for historyModel in historyPostModels {
            serverManager.postHistory(historyModel, result: { (response, nil) in
                print(response)
            })
        }
    }
    
    func encode<T: Codable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}

// Make Dictionary
extension WatchSessionIOSReplyDataProvider {
    func makeReplyDictionary(from dataProviderResult: DataProviderResult<[Data]>, dataType: WatchSessionDataKey) -> [String: Any] {
        switch dataProviderResult {
        case .Failure(let failureErrorType):
            return makeErrorDictionary(from: failureErrorType)
        case .Success(let data):
            return makeDataDictionary(from: data, dataType: dataType)
        }
    }
    
    func makeDataDictionary(from datas: [Data], dataType: WatchSessionDataKey) -> [String: Any] {
        return ["data": [dataType.rawValue: datas]]
    }
    
    func makeErrorDictionary(from errorType: WatchSessionDataFailure) -> [String: String] {
        return ["error": errorType.rawValue]
    }
}

// Data
extension WatchSessionIOSReplyDataProvider {
    func categoriesData(resultClosure: @escaping (_ categoriesDatas: DataProviderResult<[Data]>) -> Void) {
        categories { (categoriesDataResult) in
            self.handleServerResultWithArray(result: categoriesDataResult, dataProviderResultClosure: { (encodedResult) in
                resultClosure(encodedResult)
            })
        }
    }
    
    func questionsData(fromMessageRequest message: [String: Any], resultClosure: @escaping (_ questionsDatas: DataProviderResult<[Data]>) -> Void) {
        guard let questionsRequestParams = self.messageDataParser.questionsRequestParams(from: message) else {
            resultClosure( .Failure(WatchSessionDataFailure.unknown))
            return
        }
        
        self.questions(fromCategoryID: questionsRequestParams.categoryID, offset: questionsRequestParams.offset, pageSize: questionsRequestParams.pageSize)
        { (questionsDataResult) in
            self.handleServerResultWithArray(result: questionsDataResult, dataProviderResultClosure: { (encodedResult) in
                resultClosure(encodedResult)
                return
            })
        }
    }
    
    func historiesData(resultClosure: @escaping (_ historiesDataResult: DataProviderResult<[Data]>) -> Void) {
        histories { (historiesDataResult) in
            self.handleServerResultWithArray(result: historiesDataResult, dataProviderResultClosure: { (encodeResult) in
                resultClosure(encodeResult)
                return
            })
        }
    }
}

// Server Manager
extension WatchSessionIOSReplyDataProvider {
    func categories(resultClosure: @escaping (_ categories: DataProviderResult<[QuizTestCategory]>) -> Void) {
        serverManager.categories { (serverManagerResponse, categories) in
            let categoriesResult = self.handleServerManagerResult(serverManagerResponse: serverManagerResponse, data: categories)
            resultClosure(categoriesResult)
        }
    }
    
    func questions(fromCategoryID categoryID: String, offset: Int, pageSize: Int, resultClosure: @escaping (_ categories: DataProviderResult<[QuizTestQuestion]>) -> Void) {
        serverManager.questions(fromCategoryID: categoryID, offset: offset, pageSize: pageSize) { (serverManagerResponse, questions) in
            let questionsResult = self.handleServerManagerResult(serverManagerResponse: serverManagerResponse, data: questions)
            resultClosure(questionsResult)
        }
    }
    
    func histories(resultClosure: @escaping (_ histories: DataProviderResult<[QuizTestHistory]>) -> Void) {
        serverManager.history { (serverManagerResponse, histories) in
            let historiesResult = self.handleServerManagerResult(serverManagerResponse: serverManagerResponse, data: histories)
            resultClosure(historiesResult)
        }
    }
}

// Handle
extension WatchSessionIOSReplyDataProvider {
    func handleServerResultWithArray<ResultModelType: Codable>(result: DataProviderResult<[ResultModelType]>,
                                                               dataProviderResultClosure: @escaping (_ encodedDataResult: DataProviderResult<[Data]>) -> Void) {
        switch result {
        case .Success(let models):
            let datas = models.map {
                return self.encode(data: $0)
                }.flatMap{$0}
            
            if datas.count > 0 {
                dataProviderResultClosure(.Success(datas))
            } else {
                dataProviderResultClosure(DataProviderResult.Failure(WatchSessionDataFailure.unknown))
            }
        case .Failure(let error):
            dataProviderResultClosure(.Failure(error))
        }
    }
    
    func handleServerManagerResult<T>(serverManagerResponse: QuizServerResponse, data: T?) -> DataProviderResult<T> {
        switch serverManagerResponse {
        case .successful:
            guard let data = data else { return DataProviderResult.Failure(.unknown) }
            return DataProviderResult.Success(data)
        case .cantConnectToServer:
            return DataProviderResult.Failure(.noServerConnection)
        case .notConnectedToInternet:
            return DataProviderResult.Failure(.noInternetConnection)
        case .unauthorized:
            return DataProviderResult.Failure(.unauthorized)
        default:
            return DataProviderResult.Failure(.unknown)
        }
    }
}
