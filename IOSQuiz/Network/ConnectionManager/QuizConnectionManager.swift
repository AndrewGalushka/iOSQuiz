//
//  QuizConnectionManager.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum QuizConnectionResponseStatus: Int {
    
    case successful = 200
    
    case notConnectedToInternet = -1009
    case cantConnectToServer = -1004
    
    case unauthorized = 401
    
    case badRequest = 400
    case internalServerError = 500
    
    case unknownError
    
    
    func isResponseFromServer() -> Bool {
        if self == .notConnectedToInternet || self == .cantConnectToServer {
            return false
        }
        
        return true
    }
}

protocol QuizConnectionManagerType {
    func request(urlRequest: URLRequest, result: @escaping (_ responseStatus: QuizConnectionResponseStatus, _ data: Data?) -> Void)
}

class QuizConnectionManager: QuizConnectionManagerType {
    
    func request(urlRequest: URLRequest, result: @escaping (_ responseStatus: QuizConnectionResponseStatus, _ data: Data?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            if error != nil {
                let errorCode = (error! as NSError).code
            
                guard let connetionErrorStatus = self?.quizConnectionStatus(from: errorCode) else { return }
                
                result(connetionErrorStatus, nil)
                return
            }
            
            guard let fetchedData = data else {
                return
            }
            
            guard let httpResponce = response as? HTTPURLResponse else {
                return
            }
           
            guard let connetionErrorStatus = self?.quizConnectionStatus(from: httpResponce.statusCode) else { return }
            
            result(connetionErrorStatus, fetchedData)
            return
        }
        
        task.resume()
    }
    
    func quizConnectionStatus(from code: Int) -> QuizConnectionResponseStatus {
        
        guard let quizConnectionStatus = QuizConnectionResponseStatus(rawValue: code) else {
            return QuizConnectionResponseStatus.unknownError
        }
        
        return quizConnectionStatus
    }
}
