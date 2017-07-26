//
//  QuizRequestRouter.swift
//  IOSQuiz
//
//  Created by galushka on 6/15/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation


enum QuizRequestRouter {
    static private let baseURLString = "http://172.17.5.151:9999"
    
    case signIn(signParams: [String: Any])
    case signUp(signParams: [String: Any])
    case logOut(token: String)
    case categories(token: String)
    case questions(token: String, categoryID: String, offset: Int, pageSize: Int)
    case postHistory(token: String, [String: Any])
    case isTokenValid(token: String)
    case history(token: String)
    
    func urlRequest() -> URLRequest {
        
        let method: String = {
            switch self {
            case .signUp, .signIn, .logOut, .postHistory:
                return "POST"
                
            default:
                return "GET"
            }
        }()
        
        let path: String = {
            var  path = ""
            
            switch self {
            case .signIn:
                path = "/login"
            case .signUp:
                path = "/register"
            case .logOut:
                path = "/logout"
            case .categories:
                path = "/category"
            case .questions(_, categoryID: let categoryID, let offset, let pageSize):
                path = "/category?where=\(categoryID)&offset=\(offset)&pageSize=\(pageSize)"
            case .postHistory:
                path = "/history"
            case .isTokenValid(let userToken):
                path = "/token?token=\(userToken)"
            case .history(_):
                path = "/history"
            }
            
            return path
        }()
        
        guard let url = URL(string: QuizRequestRouter.baseURLString + path) else {fatalError("")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        if let fetchedParams = params {
            if let jsonParams = try? JSONSerialization.data(withJSONObject: fetchedParams, options: []) {
                urlRequest.httpBody = jsonParams
            }
        }
        
        for (key, value) in httpHeaders {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    var params: [String: Any]? {
        switch self {
        case .signIn(let httpBody):
            return httpBody
        case .signUp(let httpBody):
            return httpBody
        case .postHistory(token: _, let httpBody):
            return httpBody
        default:
            return nil
        }
    }
    
    var token: String? {
        switch self {
        case .logOut(let token):
            return token
        case .categories(let token):
            return token
        case .postHistory(let token, _):
            return token
        case .isTokenValid(let token):
            return token
        case .questions(let token, _, _, _):
            return token
        case .history(let token):
            return token
        default:
            return nil
        }
    }
    
    var httpHeaders: [String: String] {
        var headers = [String: String]()
    
        headers["Content-Type"] = "application/json"
        
        if let fetchedToken = token {
            headers["token"] = fetchedToken
        }
        
        return headers
    }
    
}
