//
//  InTestHistoryInteractor.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol InTestHistoryInteractorType {
    func historyResult(byIndex: UInt) -> QuizTestHistoryResult?
}

class InTestHistoryInteractor {
    private(set) var history: QuizTestHistory
    
    init(history: QuizTestHistory) {
        self.history = history
    }
}

extension InTestHistoryInteractor: InTestHistoryInteractorType {
    func historyResult(byIndex index: UInt) -> QuizTestHistoryResult? {
        let results = history.results
        
        if index > (results.count - 1) {
            return nil
        }
        
        return results[Int(index)]
    }
}
