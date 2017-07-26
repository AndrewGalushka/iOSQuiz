//
//  MainScreenModelView.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class MainScreenViewModel {
    private let sessionReceiveReplyModule: WatchSessionReceiveReplyModuleType
    var isProcessesTapOnCategoriesRow = false
    var failureRequestClosureHandler: ((WatchSessionDataFailure) -> Void)?
    let dataStorage = MainScreenDataStorage()
    
    init(sessionReceiveReplyModule: WatchSessionReceiveReplyModuleType) {
        self.sessionReceiveReplyModule = sessionReceiveReplyModule
    }
    
    func categories(success successClosure: @escaping (_ categories: [QuizTestCategory]) -> Void,
                    failure failureClosure: ((_ failureType: WatchSessionDataFailure) -> Void)? = nil) {
        
        if !dataStorage.categories.isEmpty {
            successClosure(dataStorage.categories)
            return
        }
            
        
        sessionReceiveReplyModule.categories { [weak self] (categoriesResult) in
            guard let strongSelf = self else { return }
            
            switch categoriesResult {
            case .Success(let categories):
                strongSelf.dataStorage.saveCategories(categories)
                successClosure(categories)
            case .Failure(let failure):
                strongSelf.handleFailureRequest(failureType: failure)
                
                if let failureClosure = failureClosure {
                    failureClosure(failure)
                }
            }
        }
    }
    
    func questions(requestParams: QuestionRequestParams,
                   success successClosure: @escaping (_ question: [QuizTestQuestion]) -> Void,
                   failure failureClosure: ((_ failureType: WatchSessionDataFailure) -> Void)? = nil) {
        sessionReceiveReplyModule.questions(categoryID: requestParams.categoryID,
                                            offset: requestParams.offset,
                                            pageSize: requestParams.pageSize,
                                            resultClosure: { [weak self]  (questionsResult) in
                                                switch questionsResult {
                                                case .Success(let questions):
                                                    successClosure(questions)
                                                case .Failure(let failure):
                                                    guard let strongSelf = self else { return }
                                                    strongSelf.handleFailureRequest(failureType: failure)
                                                    
                                                    if let failureClosure = failureClosure {
                                                        failureClosure(failure)
                                                    }
                                                }
        })
    }
    
    private func handleFailureRequest(failureType: WatchSessionDataFailure) {
        if let failureRequestClosureHandler = self.failureRequestClosureHandler {
            failureRequestClosureHandler(failureType)
        }
    }
}
