//
//  QuizAuthModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum QuizAuthModuleResult {
    case successful
    
    case wrongSignIn
    case wrongSignUp
    
    case notConnetedToInternet
    case cantConnectToServer
    case unknownError
    
    func isResultFromServer() -> Bool {
        
        if self == .notConnetedToInternet || self == .cantConnectToServer {
            return false
        }
        
        return true
    }
}

protocol QuizAuthModuleType {
    func signUp(signParams: QuizSignParams,  result: @escaping(_ result: QuizAuthModuleResult,_ ErrorMessage: String?) -> Void)
    func signIn(signParams: QuizSignParams,  result: @escaping(_ result: QuizAuthModuleResult,_ ErrorMessage: String?) -> Void)
}

class QuizAuthModule: QuizAuthModuleType {
    
    private let wrongSignInParams = "Wrong email or password"
    
    private let serverManager = QuizServerManager()
    
    func signUp(signParams: QuizSignParams,  result: @escaping(_ result: QuizAuthModuleResult,_ ErrorMessage: String?) -> Void) {
        
        serverManager.signUp(signParams: signParams) { [weak self] (response, errorMessage) in
            
            if response == .successful {
                result(.successful, nil)
                
            } else if response == QuizServerResponse.wrongSignUpParams {
                result(.wrongSignUp, errorMessage)
                
            } else
                if let authModuleResult = self?.ifServerResponseStatusFromURLSessionConvert(serverResponseToAuthModuleResult: response)  {
                    result( authModuleResult, nil)

                } else {
                    result( .unknownError, nil)
            }
        }
    }
    
    func signIn(signParams: QuizSignParams,  result: @escaping(_ result: QuizAuthModuleResult,_ ErrorMessage: String?) -> Void) {
        serverManager.signIn(signParams: signParams) { [weak self] (response, errorMessage) in
            
            if response == .successful {
                result(.successful, nil)
                
            } else if response == .unauthorized {
                
                result(.wrongSignIn, self?.wrongSignInParams)
                
            } else
                if let authModuleResult = self?.ifServerResponseStatusFromURLSessionConvert(serverResponseToAuthModuleResult: response)  {
                    result( authModuleResult, nil)
                } else {
                   result(.unknownError, nil)
            }
        }
    }
    
    func isUserTokenValid(_ complition: @escaping (_ result: Bool) -> Void) {
        serverManager.isUserTokenValid { (result) in
            complition(result)
        }
    }
    
    func ifServerResponseStatusFromURLSessionConvert(serverResponseToAuthModuleResult serverResponse: QuizServerResponse) -> QuizAuthModuleResult? {

        guard serverResponse.isResponseFromServer() == false else {
            return nil
        }
        
        if serverResponse == .cantConnectToServer {
            return .cantConnectToServer
            
        } else if serverResponse == .notConnectedToInternet {
            return .notConnetedToInternet
        }
        
        return nil
    }
}
