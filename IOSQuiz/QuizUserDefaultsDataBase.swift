//
//  QuizUserDefaultDataBase.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol QuizUserDefaultsDataBaseType {
    func saveToken(_ token: String)
    func getToken() -> String?
    func removeToken()
}

class QuizUserDefalutsDataBase: QuizUserDefaultsDataBaseType {
    let tokenKey = "QuizUserDefalutDataBaseTokenKey"
    let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
        userDefaults.synchronize()
    }
    
    func getToken() -> String? {
        guard let token = userDefaults.object(forKey: tokenKey) as? String else {
            return nil
        }
        
        return token
    }
    
    func removeToken() {
        userDefaults.removeObject(forKey: tokenKey)
    }
}
