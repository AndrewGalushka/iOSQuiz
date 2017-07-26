//
//  InTestInteractor.swift
//  IOSQuiz
//
//  Created by galushka on 7/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation


class WCInTestInteractor {
    weak var presentor: WCInTestInteractorOutput? = nil
    
    private var wcSessionDataManager: WatchSessionReceiveReplyModuleType?
    private var quizTestCategory: QuizTestCategory
    private var dataCache: InTestDataCacheType? = nil
    private var dataStorage = InTestDataStorage()
    
    init(wcSessionDataManager: WatchSessionReceiveReplyModuleType, category: QuizTestCategory) {
        self.wcSessionDataManager = wcSessionDataManager
        self.quizTestCategory = category
    }
    
    func setDataCache(_ dataCache: InTestDataCacheType) {
        self.dataCache = dataCache
    }
    
    private struct QuestionRequestParams {
        let categoryID: String
        let offset: Int
    }
}

extension WCInTestInteractor: WCInTestInteractorInput {
    func requestQuestion(byIndex index: UInt) {
        guard
            presentor != nil
        else { return }
        
        let request = WCInTestInteractor.QuestionRequestParams(categoryID: quizTestCategory.categoryID, offset: Int(index))
        
        question(requestParams: request,
                 successClosure: { [weak self] (question) in
                    guard let strongSelf = self else { return }
                    strongSelf.presentor?.receiveQuestion(question)
                }, failureClusure: { (failureType) in
                    print(failureType)
                }, unresolvedError: {
                    print("unresolvedERROR")
                })
    }
    
    func retrieveQuestion(byIndex index: UInt,
                          resultClosure: @escaping (_ question: QuizTestQuestion) -> Void,
                          errorClosure: @escaping () -> Void) {
        
        let request = WCInTestInteractor.QuestionRequestParams(categoryID: quizTestCategory.categoryID, offset: Int(index))
        
        question(requestParams: request,
                 successClosure: { (question) in
                    resultClosure(question)
            }, failureClusure: { (failureType) in
                errorClosure()
        }, unresolvedError: {
            errorClosure()
        })
    }
    
    func addAnswer(_ quizTestAnswer: QuizTestAnswer) {
        dataStorage.addAnswer(quizTestAnswer)
    }
    
    func savedAnswersCount() -> Int {
        return dataStorage.answersCount
    }
    
    func postHistory() {
        let answers = dataStorage.testAnswers
        let date = Date().timeIntervalSince1970
        print(convert(dateToQuizHistoryDateString: convert(timeIntervalSince1970ToDate: date)))
        let historyPostModel = QuizPostHistoryModel(from: answers,
                                                    date: Int(date),
                                                    categoryName: quizTestCategory.categoryName)
        wcSessionDataManager?.postHistory(historyPostModel: historyPostModel)
    }
}

extension WCInTestInteractor {
    
    private func question(requestParams: QuestionRequestParams,
                          successClosure: @escaping (_ question: QuizTestQuestion) -> Void,
                          failureClusure: @escaping (_ failureType: WatchSessionDataFailure) -> Void,
                          unresolvedError: @escaping () -> Void ) {
        guard
            presentor != nil
        else {
            unresolvedError()
            return
        }
        
        if let questionFromCache = dataCache?.question(byIndex: UInt(requestParams.offset)) {
            print("Retrieving Data from InTestViper cache\(arc4random() % 255)")
            print(questionFromCache)
            successClosure(questionFromCache)
            return
        }
        
        wcSessionDataManager?.questions(categoryID: quizTestCategory.categoryID, offset: requestParams.offset, pageSize: 1) { [weak self] (questionsResult) in
            guard
                let strongSelf = self
            else {
                unresolvedError()
                return
            }
            
            switch questionsResult {
            case .Success(let questions):
                guard let question = questions.first else {
                    unresolvedError()
                    return
                }
                
                if let dataCache = strongSelf.dataCache {
                    dataCache.addQuestion(question)
                }
                
                successClosure(question)
            case .Failure(let failureType):
                failureClusure(failureType)
            }
        }
    }
    
}

