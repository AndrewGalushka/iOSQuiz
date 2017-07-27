//
//  InTestDataCache.swift
//  IOSQuiz
//
//  Created by galushka on 7/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class InTestDataCache {
    private lazy var questionsCache = [QuizTestQuestion]()
}

extension InTestDataCache: InTestDataCacheRetrieveType {
    func question(byIndex index: UInt) -> QuizTestQuestion? {
        if index > (questionsCache.count - 1) {
            return nil
        }
        
        return questionsCache[Int(index)]
    }
}

extension InTestDataCache: InTestDataCacheAddType {
    func addQuestion(_ question: QuizTestQuestion) {
        questionsCache.append(question)
    }
}





