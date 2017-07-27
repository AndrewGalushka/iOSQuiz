//
//  QuizServerManager.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum QuizServerResponse {
    case successful
    case unauthorized
    
    case wrongSignUpParams
    
    case notConnectedToInternet
    case cantConnectToServer
    
    case serverInternalError
    
    case unknownError
    
    func isResponseFromServer() -> Bool {
        if self == .notConnectedToInternet || self == .cantConnectToServer {
            return false
        }
        
        return true
    }
}

protocol QuizServerManagerType {
    var token: String? {get}
    
    func signUp(signParams: QuizSignParams, result: @escaping (_ response: QuizServerResponse, _ data: String?) -> Void)
    func signIn(signParams: QuizSignParams, result: @escaping (_ response: QuizServerResponse, _ data: String?) -> Void)
    func isUserTokenValid(_ complition: @escaping (_ result: Bool) -> Void)
    func logOut()
    
    func categories(result: @escaping (_ response: QuizServerResponse, _ categories: [QuizTestCategory]?) -> Void)
    
    func questions(fromCategoryID categoryID: String, offset: Int, pageSize: Int, result: @escaping (_ response: QuizServerResponse,_ data: [QuizTestQuestion]?) -> Void)
    
    func postHistory(_ postHistoryModel: QuizPostHistoryModel, result: @escaping (_ response: QuizServerResponse, _ errorLog: String?) -> Void)
    func history(result: @escaping (_ respose: QuizServerResponse, _ history: [QuizTestHistory]?) -> Void)
}


class QuizServerManager: QuizServerManagerType {
    
    private let userDefaultDataBase: QuizUserDefaultsDataBaseType
    private let connectionManager: QuizConnectionManagerType
    private let dataParser = QuizServerDataParser()
    
    var token: String? {
        return userDefaultDataBase.getToken()
    }
    
    init() {
        userDefaultDataBase = QuizUserDefalutsDataBase()
        connectionManager = QuizConnectionManager()
    }
    
    func signUp(signParams: QuizSignParams, result: @escaping (_ response: QuizServerResponse, _ data: String?) -> Void) {
        
        let urlRequest = urlRequestSignUp(signParams: signParams)
        connectionManager.request(urlRequest: urlRequest) {[weak self] (quizConnectionResponseStatus, data) in
            
            if quizConnectionResponseStatus == .successful {
                result( .successful, nil)
                return
            }
            
            if let serverResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(serverResponseStatus, nil)
                return
            }
            
            guard let fetchedData = data else {
                fatalError("")
            }
            
            if quizConnectionResponseStatus == .badRequest || quizConnectionResponseStatus == .internalServerError {
                let errorMessage = self?.dataParser.error(data: fetchedData)
                result(.wrongSignUpParams, errorMessage)
                return
            } else if quizConnectionResponseStatus == .unauthorized {
                result(.unauthorized, nil)
                return
            }
            
            result(.unknownError, nil)
        }
    }
    
    func signIn(signParams: QuizSignParams, result: @escaping (_ response: QuizServerResponse, _ data: String?) -> Void) {
        let urlRequest = urlRequestSignIn(signParams: signParams)
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, data) in
            
            if let serverResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(serverResponseStatus, nil)
                return
            }
            
            guard let fetchedData = data else {
                result(.unknownError, nil)
                return
            }
            
            if quizConnectionResponseStatus == .successful {
            
                guard let fetchedToken = self?.dataParser.token(data: fetchedData) else {return}
                
                self?.userDefaultDataBase.saveToken(fetchedToken)
                result( .successful, nil)
                return
                
            } else if quizConnectionResponseStatus == .unauthorized {
        
                let errorMessage = self?.dataParser.error(data: fetchedData)
                result(.unauthorized, errorMessage)
            }
        }
    }
    
    func isUserTokenValid(_ complition: @escaping (_ result: Bool) -> Void) {
        
        guard let urlRequest = urlRequestIsTokenValid() else {
            complition(false)
            return
        }
        
        connectionManager.request(urlRequest: urlRequest) { (responseStatus, _) in
            
            if responseStatus == .successful {
                complition(true)
                return
            } else {
                complition(false)
                return
            }
        }
    }
    
    func logOut() {
        guard let urlRequest = urlRequestLogOut() else { return }
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, data) in
           
            if quizConnectionResponseStatus == .successful {
                self?.userDefaultDataBase.removeToken()
            } else {
                return
            }
        }
    }
    
    func categories(result: @escaping (_ response: QuizServerResponse, _ categories: [QuizTestCategory]?) -> Void) {
        guard let urlRequest = urlRequestCategories() else {
            result(.unauthorized, nil)
            return
        }
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, data) in
            
            if let serverResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(serverResponseStatus, nil)
                return
            }
            
            guard
                let fetchedData = data
                else {
                    result(.unknownError, nil)
                    return
            }
            
            if quizConnectionResponseStatus == .successful {
                guard let categories = self?.dataParser.categories(data: fetchedData) else {return}
                result(.successful, categories)
            } else if quizConnectionResponseStatus == .badRequest {
                result(QuizServerResponse.unknownError, nil)
            }
        }
    }

    func questions(fromCategoryID categoryID: String, offset: Int, pageSize: Int, result: @escaping (_ response: QuizServerResponse,_ data: [QuizTestQuestion]?) -> Void) {
        guard let urlRequest = urlRequestQuestions(fromCategoryID: categoryID, offset: offset, pageSize: pageSize) else {
            result(.unauthorized, nil)
            return
        }
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, data) in
            
            if let serverResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(serverResponseStatus, nil)
                return
            }
            
            guard
                let fetchedData = data
                else {
                    result(.unknownError, nil)
                    return
            }
            
            if quizConnectionResponseStatus == .successful {
                guard let data = self?.dataParser.questions(data: fetchedData) else {return}
                result(.successful, data)
            } else {
                result(.unknownError, nil)
            }
        }
    }
    
    func postHistory(_ postHistoryModel: QuizPostHistoryModel, result: @escaping (_ quizConnectionResponseStatus: QuizServerResponse, _ errorLog: String?) -> Void) {
        guard let urlRequest = urlRequestPostHistory(from: postHistoryModel) else {
            result(.unauthorized, nil)
            return
        }
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, errorLogData) in
            
            if let serverResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(serverResponseStatus, nil)
                return
            }
            
            if quizConnectionResponseStatus == .successful {
                result(.successful, nil)
            } else {
                result(.unknownError, nil)
            }
        }
    }
    
    func history(result: @escaping (_ respose: QuizServerResponse, _ history: [QuizTestHistory]?) -> Void) {
        guard let urlRequest = urlRequestHistory() else {
            result(.unauthorized, nil)
            return
        }
        
        connectionManager.request(urlRequest: urlRequest) { [weak self] (quizConnectionResponseStatus, data) in
            
            if let connectionResponseStatus = self?.ifConnectionResponseStatusFromURLSessionConvert(toServerResponse: quizConnectionResponseStatus) {
                result(connectionResponseStatus, nil)
                return
            }
            
            guard
                let fetchedData = data
                else {
                    result(.unknownError, nil)
                    return
            }
            
            if quizConnectionResponseStatus == .successful {
                let parsedData = self?.dataParser.history(data: fetchedData)
                
                result(.successful, parsedData)
                return
            } else {
                result(.unknownError, nil)
                return
            }
            
        }
    }
    
    private func urlRequestSignUp(signParams: QuizSignParams) -> URLRequest {
        
        let bodyParams: [String: String] = ["email": signParams.email, "password": signParams.password]
        
        let urlRequestRegister = QuizRequestRouter.signUp(signParams: bodyParams)
        
        return urlRequestRegister.urlRequest()
    }
    
    private func urlRequestSignIn(signParams: QuizSignParams) -> URLRequest {

        let bodyParams: [String: String] = ["email": signParams.email, "password": signParams.password]
        
        let urlRequestSignIn = QuizRequestRouter.signIn(signParams: bodyParams)
        
        return urlRequestSignIn.urlRequest()
    }
    
    private func urlRequestCategories() -> URLRequest? {
        
        guard let userToken = token else {
            debugPrint("There is no token")
            return nil
        }
        
        let urlRequestCategories = QuizRequestRouter.categories(token: userToken)
        
        return urlRequestCategories.urlRequest()
    }
    
    private func urlRequestLogOut() -> URLRequest? {

        guard let userToken = token else {
            debugPrint("There is no token")
            return nil
        }
        
        let ulrRequestRequestLogOut = QuizRequestRouter.logOut(token: userToken)
        
        return ulrRequestRequestLogOut.urlRequest()
    }
    
    private func urlRequestQuestions(fromCategoryID categoryID: String, offset: Int, pageSize: Int) -> URLRequest? {
        
        guard let userToken = token else {
            debugPrint("There is no token")
            return nil
        }
        
        let urlRequestQuestions = QuizRequestRouter.questions(token: userToken, categoryID: categoryID, offset: offset, pageSize: pageSize)
        
        return urlRequestQuestions.urlRequest()
    }
    
    private func urlRequestPostHistory(from postHistoryModel: QuizPostHistoryModel) -> URLRequest? {
        
        guard let userToken = token else {
            debugPrint("There is no token")
            return nil
        }
        
        let bodyParams: [String: Any] = encodeQuizPostHistoryModelToDictionary(postHistoryModel)
        
        let urlRequestPostHistory = QuizRequestRouter.postHistory(token: userToken, bodyParams)
        
        return urlRequestPostHistory.urlRequest()
    }
    
    private func urlRequestIsTokenValid() -> URLRequest? {
        guard let userToken = token else {return nil}
        let urlRequestIsTokenValid = QuizRequestRouter.isTokenValid(token: userToken)
        
        return urlRequestIsTokenValid.urlRequest()
    }
    
    private func encodeQuizPostHistoryModelToDictionary(_ postHistoryModel: QuizPostHistoryModel) -> [String: Any] {
        
        var questionsDictionary = [[String: Any]]()
        
        for question in postHistoryModel.questions {
            
            let questionDictionary: [String: Any] = [ "userAnswer": question.userAnswer,
                                                      "questionId": question.questionId]
            questionsDictionary.append(questionDictionary)
        }
        
        let dataDictionary = ["data" : [
            "name": postHistoryModel.categoryName,
            "date": postHistoryModel.date,
            "questions": questionsDictionary]
        ]
        
        return dataDictionary
    }
    
    private func urlRequestHistory() -> URLRequest? {
        guard let userToken = token else {return nil}
        
        let urlRequestHistory = QuizRequestRouter.history(token: userToken)
        
        return urlRequestHistory.urlRequest()
    }
    
    func ifConnectionResponseStatusFromURLSessionConvert(toServerResponse _connectionResponseStatus: QuizConnectionResponseStatus) -> QuizServerResponse? {
        
        if _connectionResponseStatus.isResponseFromServer() == false {
            
            if _connectionResponseStatus == .cantConnectToServer {
                return .cantConnectToServer
            } else {
                return .notConnectedToInternet
            }
        } else {
            return nil
        }
    }
    
}

